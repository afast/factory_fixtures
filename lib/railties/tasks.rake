namespace :factory_fixtures do

  desc 'Load fixtures defined and created with factories'
  task :load => [:environment] do
    FactoryFixtures::Loader.load_files Rails.root
  end
end

