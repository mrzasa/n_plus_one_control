module NPlusOneControl
  module Collectors
    class DB
      def initialize(pattern)
        @pattern = pattern
      end

      def subscribe
        @subscriber = ActiveSupport::Notifications.subscribe(NPlusOneControl.event, method(:callback))
      end

      def unsubscribe
        ActiveSupport::Notifications.unsubscribe(@subscriber)
      end

      def call
        @queries = []
        yield
        @queries
      end

      def callback(_name, _start, _finish, _message_id, values) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/LineLength
        return if %w[CACHE SCHEMA].include? values[:name]

        return unless @pattern.nil? || (values[:sql] =~ @pattern)

        query = values[:sql]

        if NPlusOneControl.backtrace_cleaner && NPlusOneControl.verbose
          source = extract_query_source_location(caller)

          query = "#{query}\n    ↳ #{source.join("\n")}" unless source.empty?
        end

        @queries << query
      end

      private

      def extract_query_source_location(locations)
        NPlusOneControl.backtrace_cleaner.call(locations.lazy)
          .take(NPlusOneControl.backtrace_length).to_a
      end
    end
  end
end
