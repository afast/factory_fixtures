
module FactoryFixtures
  module Loader

    def self.load_files dir
      files = find_files dir

      files.each do |file|
        load_from_file file
      end
    end

    private
    def self.load_from_file(file)
      fixture_wrapper = Class.new do
        extend FactoryFixtures::FixturesFile

        @fixtures = []
      end
      fixture_wrapper.instance_variable_set :@factory_class, factory_class_sym_from_filename(file)
      fixture_wrapper.class_eval File.read(file)

    end

    def self.find_files dir
      pattern = File.join(dir, 'test', 'factories_fixtures', '*.rb')

      found_files = Dir.glob(pattern)
    end

    def self.factory_class_sym_from_filename file
      file_basename = File.basename file, '.rb'
      file_basename.singularize.to_sym
    end
  end
end
