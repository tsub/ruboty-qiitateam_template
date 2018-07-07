require 'json'
require 'net/http'
require 'uri'

module Ruboty
  module Handlers
    class QiitateamTemplate < Base
      on %r(create template (?<id>\d+) *(?<coediting>coediting)?), name: :create, description: "generate template on #{ENV['ORGANIZATION_NAME']}.qiita.com"
      on %r(remember my qiita token (?<token>.+)\z), name: "remember", description: "Remember sender's Qiita access token"

      def create(message)
        access_tokens = message.robot.brain.data['qiitateam_template'] || {}
        access_token = access_tokens[message.from_name]
        if access_token.nil?
          message.reply("I don't know your Qiita access token")
          return
        end

        url = URI.parse("https://#{ENV['ORGANIZATION_NAME']}.qiita.com/api/v2/items")
        req = Net::HTTP::Post.new(url.path)
        req = set_headers(req, access_token)

        template = template(message[:id], access_token)
        coediting = message[:coediting] ? true : false
        data = {
          coediting: coediting,
          gist: false,
          tags: template[:tags],
          title: template[:title],
          body: template[:body]
        }.to_json

        req.body = data

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        res = http.start do |http|
          http.request(req)
        end

        created_url = JSON.load(res.body)['url']
        message.reply("created #{created_url}")
      end

      def remember(message)
        access_tokens = message.robot.brain.data['qiitateam_template'] || {}
        access_tokens[message.from_name] = message[:token]
        message.robot.brain.data['qiitateam_template'] = access_tokens
        message.reply("Remembered #{message.from_name}'s Qiita access token")
      end

      private
      def template(id, access_token)
        url = URI.parse("https://#{ENV['ORGANIZATION_NAME']}.qiita.com/api/v2/templates/#{id}")
        req = Net::HTTP::Get.new(url.request_uri)
        req = set_headers(req, access_token)

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        res = http.start do |http|
          http.request(req)
        end

        json = JSON.load(res.body)

        {title: json["expanded_title"], body: json["expanded_body"], tags: json["tags"]}
      end

      def set_headers(req, access_token)
        req['Accept'] = 'application/json'
        req['Content-Type'] = 'application/json; charset=utf-8'
        req['Authorization'] = "Bearer #{access_token}"

        req
      end
    end
  end
end

