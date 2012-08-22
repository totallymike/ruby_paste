$:.unshift(File.expand_path("..", File.dirname(__FILE__)))
require "cuba/test"
require "main"

scope do
  test "Homepage" do
    get "/"
    assert last_response.body["curl"]
  end
  test "CSS" do
    get "css/style.css"
    assert last_response.body.include? "Boilerplate"
  end
  test "JS" do
    get "js/script.js"
    assert last_response.body.include? "Author"
  end
  test "JSLibsWork" do
    get "js/libs/modernizr-2.5.3.min.js"
    assert last_response.body.include? "Modernizr"
  end
  test "Settings" do
    assert_equal "http://localhost:5984/default", Cuba.settings[:couch]
  end
end
