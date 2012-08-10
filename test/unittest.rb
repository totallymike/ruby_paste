$:.unshift(File.expand_path("..", File.dirname(__FILE__)))
require "main"
require "cuba/test"

scope do
  test "Homepage" do
    get "/"

    assert last_response.body["POST"]
  end
end

