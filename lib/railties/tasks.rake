namespace :factory_fixtures do

  desc 'TODO: describme me please!'
  task :load => [:environment] do
    FactoryFixtures::Loader.load_files Rails.root
  end
end

