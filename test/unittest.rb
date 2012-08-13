$:.unshift(File.expand_path("..", File.dirname(__FILE__)))
require "main"
require "cuba/test"

scope do
  test "Homepage" do
    get "/"
    assert last_response.body["curl"]
  end
  test "CSS" do
    get "css/style.css"
    assert last_response.body["Boilerplate"]
  end
  test "JS" do
    get "js/script.js"
    assert last_response.body["Author"]
  end
  test "JSLibsWork" do
    get "js/libs/modernizr-2.5.3.min.js"
    assert last_response.body["Modernizr"]
  end
  test "Settings" do
    assert_equal "localhost", Cuba.settings[:couch][:server]
  end
end

