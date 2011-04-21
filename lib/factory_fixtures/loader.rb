
module FactoryFixtures

  # Loads the fixtures
  module Loader

    # Loads the fixtures found in dir
    # dir -> Directory path for searching fixtures files
    def self.load_files dir
      files = find_files dir

      files.each do |file|
        load_from_file file
      end
    end

    private
    # Loads the fixtures presents in file
    def self.load_from_file(file)

      fixtures_file = FactoryFixtures::FixturesFile.new factory_class_sym_from_filename(file)

      fixtures_file.instance_eval File.read(file)
    end

    # Searches for fixtures files present in #{dir}/test/factory_fixtures
    def self.find_files dir
      pattern = File.join(dir, 'test', 'factories_fixtures', '*.rb')

      found_files = Dir.glob(pattern)
    end

    # TODO: change this method's name to table_sym_from_filename
    def self.factory_class_sym_from_filename file
      file_basename = File.basename file, '.rb'
      file_basename.singularize.to_sym
    end
  end
end
