require 'active_record/fixtures'

module FactoryFixtures

  # Represents a fixture. The fixtures are just the objects that are instantiated
  class Fixture

    # Hash with attributes and its values
    attr_reader :fixture_data

    def initialize
      @fixture_data = {}
    end

    # Returns an identification for a fixture_label, used when specifying association values.
    def F fixture_label
      ::Fixtures.identify fixture_label
    end

    def method_missing field_name, *args, &block
      return if args.empty?

      if args.length == 1
        @fixture_data[field_name.to_sym] = args.first
      else
        @fixture_data[field_name.to_sym] = args
      end

    end
  end
end
