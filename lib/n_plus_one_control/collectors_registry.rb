# frozen_string_literal: true

module NPlusOneControl
  class CollectorsRegistry
    class << self
      attr_reader :collectors

      def register(key, collector_class)
        @collectors ||= {}
        @collectors[key] = collector_class
      end

      def slice(*keys)
        raise ArgumentError, <<~MSG unless (keys & collectors.keys).size == keys.size
          No collectors for keys: #{keys.join(", ")}, exsiting collectors are: #{collectors.keys.join(", ")}
        MSG

        collectors.slice(*keys)
      end

      def unregister(*keys)
        keys.each { |key| collectors.delete(key) }
      end
    end
  end
end
