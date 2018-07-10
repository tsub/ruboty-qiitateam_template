module Ruboty
  module QiitateamTemplate
    class Item
      def initialize(client)
        @client = client
      end

      def create(params)
        client.post('/items', params)
      end

      private

      attr_reader :client
    end
  end
end
