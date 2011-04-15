require "rails"

module FactoryFixtures
  class Engine < Rails::Engine
    
    rake_tasks do
      load "railties/tasks.rake"
    end
  end
end
