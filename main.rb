require "sass"
require 'date'
require 'couchrest'
require "cuba"
require "cuba/render"

# Allow for an optional settings file.
begin
  require "lib/settings"
rescue LoadError
  Cuba.settings[:couch] = "http://localhost:5984/default"
end

Cuba.settings[:render] = {}
Cuba.settings[:render][:template_engine] = "haml"
Cuba.plugin Cuba::Render

$db = CouchRest.database(Cuba.settings[:couch])

# Possible characters for random ID generation
$chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'

module Kernel
private
  def generate_id
    paste_id = ''
    8.times do
      paste_id += $chars[rand($chars.length)]
    end

    paste_id
  end
end


Cuba.define do
  on get do
    on "css", extension("css") do |file|
      res.headers["Content-Type"] = "text/css; charset=utf-8"
      res.write render("assets/css/#{file}.scss")
    end

    on "js" do
      res.headers["Content-Type"] = "text/javascript; charset=utf-8"
      on "libs", extension("js") do |file|
        res.write File.read("assets/js/libs/#{file}.js")
      end

      on extension("js") do |file|
        res.write File.read("assets/js/#{file}.js")
      end
    end

    on root do
      res.write view("index")
    end
  end

  on post do
    on "", param("paste") do |paste|
      response = $db.save_doc({
        :id  => generate_id,
        :doc => paste,
        :timestamp => DateTime.now.to_s
      })

      res.write "http://#{req.host}/#{response.id}"
    end
  end


end
