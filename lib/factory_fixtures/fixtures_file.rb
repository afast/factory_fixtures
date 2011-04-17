
require 'active_record/fixtures'
require 'active_support'
require 'factory_girl'

module FactoryFixtures
  module FixturesFile

    # Defines a factory
    def define factory_name
      Factory.define factory_name, :class => @factory_class do |u|
        yield u
      end
    end

    # Creates an object based on #{factory_name}
    def create fixture_name, factory_name = nil, &block
      fixture_name = fixture_name.to_sym

      if factory_name.nil?
        factory_name = @factory_class
      else
        factory_name = factory_name.to_sym
      end

      if !Factory.factories.include?(factory_name)
        define(factory_name) {|u|}
      end

      fixture = Fixture.new
      fixture.fixture_data[:id] = ::Fixtures.identify(fixture_name)
      fixture.instance_eval &block

      set_association_data fixture, @factory_class.to_s.classify.constantize

      Factory.create factory_name, fixture.fixture_data
    end

    private
    # Sets the values for the association fields
    #
    # For each association field present in <em>fixture_data</em> creates a new entry for it's FK and deletes the field entry
    def set_association_data fixture, model_class
      assocs = model_class.reflect_on_all_associations

      fixture_keys = fixture.fixture_data.keys

      assocs.each do |assoc|
        if (assoc.macro == :belongs_to) && fixture_keys.include?(assoc.name.to_sym)
          fk_name = (assoc.options[:foreign_key] || "#{assoc.name}_id").to_s
          fixture.fixture_data[fk_name] = fixture.fixture_data[assoc.name.to_sym]
          fixture.fixture_data.delete(assoc.name.to_sym)
        end
      end
    end

  end
end
