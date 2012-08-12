$:.unshift(File.expand_path("..", File.dirname(__FILE__)))
require "main"
require "cuba/test"

scope do
  test "Homepage" do
    get "/"
    assert last_response.body["curl"]
  end
  test "DefaultShouldNotServeIndex" do
    get "/js/test.js"
    assert_equal nil, last_response.body["curl"]
  end
  test "Settings" do
    assert_equal "localhost", Cuba.settings[:couch][:url]
  end
end

