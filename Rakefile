require 'rspec/core/rake_task'

require 'formulita_backend'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc 'Import data from Ergast service and generate JSON'
task :import_season, [:year] do |_, args|
  year = args.year ? args.year.to_i : Time.now.year
  FormulitaBackend::Updater.new.update(year)
end
