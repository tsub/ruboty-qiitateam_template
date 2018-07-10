module Ruboty
  module QiitateamTemplate
    module Actions
      class Create < Base
        def call
          if access_token.nil?
            message.reply("I don't know your Qiita access token")
            return
          end

          created_item = item.create({
            coediting: message[:coediting] ? true : false,
            gist:      false,
            tags:      template[:tags],
            title:     template[:expanded_title],
            body:      template[:expanded_body],
          })
          message.reply("created #{created_item[:url]}")
        end

        private

        def client
          @client ||= Ruboty::QiitateamTemplate::Client.new(access_token: access_token)
        end

        def template
          @template ||= Ruboty::QiitateamTemplate::Template.new(client).get(message[:id])
        end

        def item
          @item ||= Ruboty::QiitateamTemplate::Item.new(client)
        end
      end
    end
  end
end
