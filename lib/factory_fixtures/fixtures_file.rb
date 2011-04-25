
require 'active_record/fixtures'
require 'active_support'
require 'factory_girl'

module FactoryFixtures
  class FixturesFile

    attr_reader :factory_class

    attr_reader :fixtures # TODO test it!

    def initialize factory_class
      @factory_class = factory_class
      @fixtures = {}
    end

    # Defines a factory
    def define factory_name
      Factory.define factory_name, :class => @factory_class do |u|
        yield u if block_given?
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

      set_belongs_to_assocs fixture, @factory_class.to_s.classify.constantize
      set_habtm_assocs fixture, @factory_class.to_s.classify.constantize

      @fixtures[fixture_name] = Factory.create factory_name, fixture.fixture_data
    end

    private
    # Sets the values for the association fields
    #
    # For each association field present in <em>fixture_data</em> creates a new entry for it's FK and deletes the field entry
    def set_belongs_to_assocs fixture, model_class
      assocs = model_class.reflect_on_all_associations :belongs_to

      fixture_keys = fixture.fixture_data.keys

      assocs.each do |assoc|
        if fixture_keys.include?(assoc.name.to_sym)
          fk_name = (assoc.options[:foreign_key] || "#{assoc.name}_id").to_s
          fixture.fixture_data[fk_name] = fixture.fixture_data[assoc.name.to_sym]
          fixture.fixture_data.delete(assoc.name.to_sym)
        end
      end
    end

    def set_habtm_assocs fixture, model_class
      assocs = model_class.reflect_on_all_associations :has_and_belongs_to_many

      fixture_keys = fixture.fixture_data.keys

      assocs.each do |assoc|
        table_name = assoc.options[:join_table]
        if fixture_keys.include? assoc.name.to_sym
          assoc_data = fixture.fixture_data[assoc.name.to_sym]
          fixture.fixture_data.delete(assoc.name.to_sym)

          if !assoc_data.is_a? Array
            assoc_data = [assoc_data]
          end

          assoc_data.each do |data|
            columns_string = [assoc.primary_key_name, assoc.association_foreign_key].join(', ')
            values_string = [fixture.fixture_data[:id], data].join(', ')

            sql = "INSERT INTO #{model_class.connection.quote_table_name(table_name)} (#{columns_string}) VALUES (#{values_string})"
            model_class.connection.execute sql
          end
        end

      end
    end

  end
end
