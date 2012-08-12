require "sass"
require "cuba"
require "cuba/render"

# Allow for an optional settings file.
begin
  require "lib/settings"
rescue LoadError
  Cuba.settings[:couch] = { :server => 'localhost', :port => 5984 }
end

Cuba.use Rack::Session::Cookie
Cuba.plugin Cuba::Render

Cuba.define do
  # These functions are stolen straight from
  # https://github.com/antirez/redis-io/blob/master/app.rb
  def render(path, locals = {})
    options = {
      :format => :html5
    }

    super(path, locals, options)
  end

  def haml(template, locals = {})
    layout(partial(template, locals))
  end

  def partial(template, locals = {})
    render("views/#{template}.haml", locals)
  end

  def layout(content)
    partial("layout", content: content)
  end

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
      res.write haml("index")
    end
  end
end
