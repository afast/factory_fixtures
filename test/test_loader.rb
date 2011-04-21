require 'active_record'
require 'active_support'
require 'active_record/fixtures'
require 'factory_girl'
require 'test/unit'

require_relative '../lib/factory_fixtures/fixtures_file'
require_relative '../lib/factory_fixtures/fixture'
require_relative '../lib/factory_fixtures/loader'

require_relative 'support/test_helper'

class TestLoader < FactoryFixtures::UnitTestCase

  trans "test_load_files" do
    FactoryFixtures::Loader.load_files (File.dirname(__FILE__) + "/../")

    john = User.where(:first_name => 'john').first
    smith = User.where(:first_name => 'smith').first
    
    assert john
    assert smith

    assert_equal 'jameson', john.last_name
    assert_equal 'richardson', smith.last_name

    test_poc = Account.where(:company => 'test_poc').first
    assert test_poc

    assert_equal test_poc, john.account
    assert_equal test_poc, smith.account

  end
end
