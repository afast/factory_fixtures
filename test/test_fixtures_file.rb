require 'active_record'
require 'factory_girl'
require 'test/unit'

require_relative '../lib/factory_fixtures/fixtures_file'
require_relative '../lib/factory_fixtures/fixture'

require_relative 'support/test_helper'

class TestFixturesFile < FactoryFixtures::UnitTestCase

  def setup
      @accounts = FactoryFixtures::FixturesFile.new :account
      @cities = FactoryFixtures::FixturesFile.new :city
      @users = FactoryFixtures::FixturesFile.new :user

      @users.define :simple_user      

      @users.define :regular_user do |u|
        u.email { |u| "#{u.first_name}.#{u.last_name}@example.org" }
        u.encrypted_password '$2a$10$xMfCF.PExnD59a5F3hBV1eKTi6t3YZAUw7y0VspO3Z.sx.xgl9kcG'
        u.password_salt '$2a$10$xMfCF.PExnD59a5F3hBV1e'
      end

      @accounts.define :simple_account do |a|
        a.is_verified true
        a.zip { "#{rand 10}" * 5 }
      end
  end

  def teardown
    Factory.factories.clear
  end

  def test_new
    f = FactoryFixtures::FixturesFile.new :person

    assert_equal :person, f.factory_class
  end

  def test_define
    license_number = "00XX - YY - ZZ"

    f = FactoryFixtures::FixturesFile.new :person

    f.define :adult do |adult|
      adult.driver_license license_number
    end

    assert Factory.factories.include?(:adult)

    factory = Factory.factory_by_name :adult

    assert_equal :driver_license, factory.attributes[0].name
    assert_equal license_number, factory.attributes[0].instance_variable_get(:@value)
  end

  trans :test_create do
    @users.create :james, :simple_user do

      first_name 'james'
      last_name 'jameson'
    end

    assert_equal 1, User.count

    james_id = FactoryFixtures::Fixture.new.F(:james)

    james = User.find(james_id)
    assert james

    assert_equal james.first_name, 'james'
    assert_equal james.last_name, 'jameson'
  end

  trans :test_create_without_factory do
    @users.create :john do
      first_name 'john'
    end

    assert_equal 1, User.count

    john_id = FactoryFixtures::Fixture.new.F(:john)

    john = User.find(john_id)
    assert john

    assert_equal john.first_name, 'john'
  end

  trans :test_create_with_factory_values do
    @users.create :james, :regular_user do
      first_name 'james'
      last_name 'jameson'
    end

    james_id = FactoryFixtures::Fixture.new.F(:james)

    james = User.find(james_id)

    assert_equal 'james.jameson@example.org', james.email
  end

  trans :test_belongs_to_associatons do
    @accounts.create :acc_a, :simple_account do
      company "AAA & Co"
    end

    acc_a = Account.find(FactoryFixtures::Fixture.new.F(:acc_a))

    @users.create :james, :regular_user do
      first_name 'james'
      account F(:acc_a)
    end

    james = User.find(FactoryFixtures::Fixture.new.F(:james))

    assert_equal acc_a, james.account
  end

  trans :test_habtm_to_associatons do
    @cities.create :tokyo do
      name 'Tokyo'
    end

    @cities.create :kyoto do
      name 'Kyoto'
    end

    @users.create :akira do
      first_name 'Akira'
      cities F(:tokyo), F(:kyoto)
    end

    tokyo = City.where(:name => 'Tokyo').first
    kyoto = City.where(:name => 'Kyoto').first

    akira = User.where(:first_name => 'Akira').first

    assert akira.cities.include?(tokyo)
    assert akira.cities.include?(kyoto)
  end

end

