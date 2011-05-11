require 'active_support'
require 'factory_girl'
require 'declarative_authorization/maintenance'

module FactoryFixtures
  module Unit

    class TestCase < ActiveSupport::TestCase
      include Authorization::TestHelper

      ATTR_BASE_DIR_SEARCH = 'base_dir_search'
      ATTR_FIXTURES_TO_LOAD = 'factory_fixtures_to_load'
      
      def self.inherited klass
        super

        file = file_from_stackline caller.first

        base_dir_search = File.join File.dirname(file), '..', 'factories_fixtures'
        klass.write_inheritable_attribute(ATTR_BASE_DIR_SEARCH, base_dir_search)

        fixtures_file_basename = "#{klass.name.gsub(/Test$/, '').tableize}.rb"

        fixture_file = File.join base_dir_search, fixtures_file_basename

        klass.write_inheritable_attribute(ATTR_FIXTURES_TO_LOAD, [fixture_file])
        factory_fixtures_to_load = klass.read_inheritable_attribute(ATTR_FIXTURES_TO_LOAD)
      end

      def self.factory_fixtures(*table_names)
        fixtures_files = table_names.collect do |table_name|
          File.join read_inheritable_attribute(ATTR_BASE_DIR_SEARCH), "#{table_name}.rb"
        end

        write_inheritable_attribute(ATTR_FIXTURES_TO_LOAD, fixtures_files)
      end

      def setup
        super
        ::Factory.factories.clear

        factory_fixtures_to_load = self.class.read_inheritable_attribute(ATTR_FIXTURES_TO_LOAD)

        return if factory_fixtures_to_load.nil?
        
        fixtures_loaded = factory_fixtures_to_load.select do |file|
          fixtures = without_access_control do
            FactoryFixtures::Loader.load_from_file file.to_s
          end
          self.class.send :define_method, File.basename(file, '.rb') do
            fixtures
          end
        end

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

