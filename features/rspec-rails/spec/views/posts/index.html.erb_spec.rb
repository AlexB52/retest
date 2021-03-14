require 'rails_helper'

RSpec.describe "posts/index", type: :view do
  before(:each) do
    assign(:posts, [
      Post.create!(
        title: "Title"
      ),
      Post.create!(
        title: "Title"
      )
    ])
  end

  it "renders a list of posts" do
    render
    assert_select "tr>td", text: "Title".to_s, count: 2
  end
end
