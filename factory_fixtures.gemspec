# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  # If you add a development dependency, please maintain alphabetical order
  # If you add a runtime dependency, please maintain alphabetical order
  s.add_runtime_dependency('factory_girl_rails', '~> 1.0.1')
  s.add_runtime_dependency('rails', '~> 3.0.3')
  s.authors = ["snmgian"]
  s.email = ['snmgian@gmail.com', 'gian.zas@moove-it.com']
  s.files = Dir['Gemfile', 'LICENSE.mkd', 'README.mkd', 'Rakefile', 'app/**/*', 'config/**/*', 'lib/**/*', 'public/**/*']
  s.name = 'factory_fixtures'
  s.platform = Gem::Platform::RUBY
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=
  s.summary = %q{Factory girl fixtures for Rails}
  # FIXME: this should reference NmxFixtures::VERSION but because of
  # http://jira.codehaus.org/browse/JRUBY-5319 we can't use "require"
  # in our gemspec
  s.version = '0.0.1'
end
