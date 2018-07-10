module Ruboty
  module QiitateamTemplate
    class Template
      def initialize(client)
        @client = client
      end

      def get(id)
        client.get("templates/#{id}")
      end

      private

      attr_reader :client
    end
  end
end
