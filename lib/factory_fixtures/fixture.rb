require 'active_record/fixtures'

module FactoryFixtures
  class Fixture
    attr_reader :fixture_data
    def initialize
      @fixture_data = {}
    end

    def F fixture_label
      ::Fixtures.identify fixture_label
    end

    def method_missing field_name, *args, &block
      if !args.empty?
        @fixture_data[field_name.to_sym] = args.first
      end
    end
  end
end
