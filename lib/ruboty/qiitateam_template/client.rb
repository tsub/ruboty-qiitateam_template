require 'json'
require 'net/http'
require 'uri'

module Ruboty
  module QiitateamTemplate
    class Client
      BASE_URL = "https://#{ENV['ORGANIZATION_NAME']}.qiita.com/api/v2"

      def initialize(access_token: nil)
        @access_token = access_token
      end

      def get(endpoint)
        uri = URI.parse(BASE_URL + endpoint)
        req = Net::HTTP::Get.new(uri.request_uri)
        req = set_headers(req)

        http_request(uri, req)
      end

      def post(endpoint, params)
        uri = URI.parse(BASE_URL + endpoint)
        req = Net::HTTP::Post.new(uri.path)
        req = set_headers(req)

        req.body = params.to_json

        http_request(uri, req)
      end

      private

      attr_reader :access_token

      def http_request(uri, req)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        res = http.start do |http|
          http.request(req)
        end

        JSON.load(res.body, symbolize_names: true)
      end

      def set_headers(req)
        req['Accept'] = 'application/json'
        req['Content-Type'] = 'application/json; charset=utf-8'
        req['Authorization'] = "Bearer #{access_token}"

        req
      end
    end
  end
end
