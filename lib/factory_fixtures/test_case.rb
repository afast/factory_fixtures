require 'active_support'
require 'factory_girl'

module FactoryFixtures
  module Unit

    class TestCase < ActiveSupport::TestCase
      ATTR_FIXTURES_TO_LOAD = 'factory_fixtures_to_load'
#
#      # Registers the fixtures to be loaded on setup
#      def self.factory_fixtures(*table_names)
#        write_inheritable_attribute(ATTR_FIXTURES_TO_LOAD, table_names)
#      end
      
      def self.inherited klass
        super

        puts "INHERITED!"
        file = file_from_stackline caller.first
        base_dir_search = File.join File.dirname(file), '..', 'factories_fixtures'

        fixtures_file_basename = "#{klass.name.gsub(/Test$/, '').tableize}.rb"

        fixture_file = File.join base_dir_search, fixtures_file_basename

        klass.write_inheritable_attribute(ATTR_FIXTURES_TO_LOAD, [fixture_file])
        factory_fixtures_to_load = klass.read_inheritable_attribute(ATTR_FIXTURES_TO_LOAD)
        puts "in inh: #{factory_fixtures_to_load}"
      end

      def setup
        super
        ::Factory.factories.clear
        puts "jaaj"

        factory_fixtures_to_load = self.class.read_inheritable_attribute(ATTR_FIXTURES_TO_LOAD)

        puts "ff: #{factory_fixtures_to_load.inspect}"
        return if factory_fixtures_to_load.nil?
        
        fixtures_loaded = factory_fixtures_to_load.select do |file|
          fixtures = FactoryFixtures::Loader.load_from_file file
          puts "fixtures: #{fixtures.inspect}"
          self.class.send :define_method, File.basename(file, '.rb') do
            fixtures
          end
        end

#
#        @loaded_fixtures = FactoriesHelper.factory_fixtures(*factory_fixtures_to_load)
#        table_name = FactoriesHelper.table_name_ut(self)
#        if !@loaded_fixtures.keys.include? table_name
#          @loaded_fixtures.merge! FactoriesHelper.load_fixtures 
#        end
#
#        @loaded_fixtures.each do |table_name, fixtures_class|
#          self.instance_variable_set("@#{table_name}", fixtures_class)
#        end
      end
    end

    def teardown
      super
      ::Factory.factories.clear
    end


  end
end

def file_from_stackline stackline
  stackline.split(/:\d/).first
end

