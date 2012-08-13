require "sass"
require "cuba"
require "cuba/render"

# Allow for an optional settings file.
begin
  require "lib/settings"
rescue LoadError
  Cuba.settings[:couch] = { :server => 'localhost', :port => 5984 }
end

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

    on root do
      res.write view("index")
    end
  end
end
