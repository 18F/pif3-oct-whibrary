require 'docsplit'
require 'pathname'
require 'sequel'
require 'yaml'
require 'csv'

require './lib/search/table'

module Search
  DB = Sequel.connect(YAML.load(File.read(Pathname(Dir.pwd) + 'config' + 'database.yml'))[ENV['SEARCH_ENV'] || 'development'])
end
