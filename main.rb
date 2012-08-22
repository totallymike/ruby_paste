require "sass"
require 'date'
require 'couchrest'
require "cuba"
require "cuba/render"

require File.join(File.dirname(__FILE__),'lib', 'models', 'paste')

Cuba.settings[:render] = {}
Cuba.settings[:render][:template_engine] = "haml"
Cuba.plugin Cuba::Render

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
      new_paste = Paste.new(:body => paste)
      begin
        new_paste.save
        res.write "http://#{req.host}/paste/#{new_paste.id}"
      rescue Exception
        res.write "Failed to create paste document."
      end


    end
  end


end
