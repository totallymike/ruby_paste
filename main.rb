require "cuba"

Cuba.use Rack::Session::Cookie

Cuba.define do
  on get do
    on root do
      res['Content-Type'] = "text/plain"
      res.write(<<EOL
Welcome to Mike's Ruby pastebin.  It does very little at the moment.
In the near future it will accept POST requests to /.  If you POST
a parameter called 'paste' it will generate a paste of the contents.
EOL
               )
    end
  end
end
