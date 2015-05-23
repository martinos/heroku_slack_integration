require 'data_mapper'
require 'dm-migrations'

class Commit
  include DataMapper::Resource

  property :id  , Serial
  property :sha , String
end
