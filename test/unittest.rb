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
  test "Settings" do
    assert_equal "localhost", Cuba.settings[:couch][:server]
  end
end

