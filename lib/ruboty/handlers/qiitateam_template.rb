module Ruboty
  module Handlers
    class QiitateamTemplate < Base
      on %r(create template (?<id>\d+) *(?<coediting>coediting)?), name: :create, description: "generate template on #{ENV['ORGANIZATION_NAME']}.qiita.com"
      on %r(remember my qiita token (?<token>.+)\z), name: "remember", description: "Remember sender's Qiita access token"

      def create(message)
        Ruboty::QiitateamTemplate::Actions::Create.new(message).call
      end

      def remember(message)
        Ruboty::QiitateamTemplate::Actions::Remember.new(message).call
      end
    end
  end
end

