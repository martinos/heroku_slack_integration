require 'bundler'
Bundler.setup

require 'data_mapper'
require 'logger'

APP_ROOT = File.expand_path(File.dirname(File.join(__FILE__)))
RACK_ENV = ENV['RACK_ENV'] || "development";

require 'dotenv'

Dotenv.load(
    File.expand_path(".#{RACK_ENV}.env"),
    File.expand_path(".env") )

LOGGER = Logger.new(STDOUT)

$LOAD_PATH.unshift(APP_ROOT)

require 'data_mapper'
DataMapper.setup(:default, ENV["DATABASE_URL"] || "sqlite3://#{APP_ROOT}/db/#{RACK_ENV}.db")

require 'commit'
DataMapper.finalize

case RACK_ENV
when "development", "production"
  # We run the migrations if not runned
  Commit.auto_upgrade!
when "test"
  # We recreate the database with the schema from scratch
  Commit.auto_migrate!
else
  raise "Invalid RACK_ENV #{RACK_ENV}"
end

