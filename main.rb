require "sass"
require 'date'
require 'couchrest'
require "cuba"
require "cuba/render"

require File.join(File.dirname(__FILE__),'lib', 'models', 'paste')

Cuba.settings[:render] = {}
Cuba.settings[:render][:template_engine] = "haml"
Cuba.plugin Cuba::Render

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

    on 'paste/:paste_id' do |id|
      paste = Paste.get(id)
      res.write view("paste", paste: paste)
    end

    on root do
      res.write view("index")
    end
  end

  on post do
    on "", param("paste") do |paste|
      new_paste = Paste.new(:body => paste, :created_at => DateTime.now) do |doc|
        # Might be a better way to manually assign document id.
        # Will look into it later.
        doc.id = generate_id
      end
      begin
        new_paste.save
        res.write "http://#{req.host}/paste/#{new_paste.id}"
      rescue Exception
        res.write "Failure!"
      end


    end
  end


end
