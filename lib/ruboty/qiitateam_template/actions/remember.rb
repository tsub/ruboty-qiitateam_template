module Ruboty
  module QiitateamTemplate
    module Actions
      class Remember < Base
        def call
          access_tokens[message.from_name] = message[:token]
          message.reply("Remembered #{message.from_name}'s Qiita access token")
        end
      end
    end
  end
end
