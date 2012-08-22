require 'couchrest_model'

class Paste < CouchRest::Model::Base
  property :body,       String
  property :created_at, Time
end
