require 'active_record'
require 'test/unit'

require_relative '../lib/factory_fixtures/fixture'

class TestFixture < Test::Unit::TestCase
    
  def test_fixture
    assert FactoryFixtures::Fixture.new
  end

  def test_set_attributes
    john = FactoryFixtures::Fixture.new

    john.name 'John'
    john.surname 'Smith'

    assert_equal 'John', john.fixture_data[:name]
    assert_equal 'Smith', john.fixture_data[:surname]
  end

  def test_override_attribute
    john = FactoryFixtures::Fixture.new

    john.name 'John'
    john.surname 'Smith'

    john.name 'Charles'

    assert_equal 'Charles', john.fixture_data[:name]
    assert_equal 'Smith', john.fixture_data[:surname]
  end

end

class TestFixtureIdentifiers < Test::Unit::TestCase

  def test_identify
    assert FactoryFixtures::Fixture.new.F(:test)
  end

  def test_non_repeated_identifiers

    symbols = randomly_unique_symbols 10
    
    identifiers = symbols.collect { |s| FactoryFixtures::Fixture.new.F(s) }
    identifiers.uniq

    assert_equal symbols.length, identifiers.length
  end

  def test_identifiers_greater_than_zero

    symbols = randomly_unique_symbols 10

    symbols.each do |s| 
      identifier = FactoryFixtures::Fixture.new.F(s)
      assert identifier > 0
    end
  end

  private
  def randomly_unique_symbols n
    symbols = []

    while symbols.length < n do
      symbols << randomly_symbol 
      symbols.uniq
    end

    symbols
  end

  def randomly_symbol
    chars = ('a'..'z').to_a << '_'
    max_length = 10

    name_length = rand(max_length) + 1

    randomly_string = ''
    name_length.times do
      randomly_string += chars[rand chars.length]
    end
    
    randomly_string.to_sym
  end
end

