require "cuba/test"
require "cuba/capybara"
require "./main"

scope do
  test "Homepage" do
    visit "/"

    assert has_content?("POST")
  end
end

