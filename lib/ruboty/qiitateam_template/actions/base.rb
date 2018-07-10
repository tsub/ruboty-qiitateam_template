module Ruboty
  module QiitateamTemplate
    module Actions
      class Base
        def initialize(message)
          @message = message
        end

        private

        attr_reader :message

        def access_tokens
          message.robot.brain.data['qiitateam_template'] ||= {}
        end

        def access_token
          access_tokens[sender_name]
        end

        def sender_name
          message.from_name
        end
      end
    end
  end
end
