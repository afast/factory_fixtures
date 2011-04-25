require 'active_record'
require 'active_support'
require 'active_support/test_case'
require 'logger'
require 'yaml'

module FactoryFixtures
  class UnitTestCase < Test::Unit::TestCase

    def self.trans test_method_sym, &block

      define_method test_method_sym do
        ActiveRecord::Base.transaction do

          self.instance_eval &block
          raise ActiveRecord::Rollback

        end
      end
    end

  end
end

def load_schema 
  load(File.dirname(__FILE__) + "/schema.rb")  
end 

def setup
  config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))  
  ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/../debug.log")  

  db_adapters = ['sqlite3', 'mysql2', 'sqlite', 'mysql']
  db_adapter = ENV['DB'] 
  
  db_adapter ||= db_adapters.find do |adapter|
    begin
      require adapter
      adapter
    rescue MissingSourceFile
    end
  end

  puts db_adapter.inspect
  if db_adapter.nil? 
    raise "No DB Adapter selected or found. Pass the DB= option to pick one, or install Sqlite or Sqlite3." 
  end

  ActiveRecord::Base.establish_connection(config[db_adapter])  

  #require File.dirname(__FILE__) + '/../rails/init.rb' 
end

setup
load_schema
require_relative 'models'

