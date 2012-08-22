require 'couchrest_model'

class Paste < CouchRest::Model::Base
  property :body,       String
  property :created_at, Time

  def initialize(attributes = {}, options = {})
    super(attributes, options)
    self.id = generate_id
    self.created_at = DateTime.now
  end

private
  # Generate an eight character id for the document.
  # Makes for shorter urls using less data per document than the
  # standard UUIDs.
  @@_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'
  def generate_id
    paste_id = ''
    8.times do
      paste_id += @@_CHARS[rand(@@_CHARS.length)]
    end

    paste_id
  end
end
