require "rails_helper"

RSpec.describe "Pages", :type => :request do
    fixtures :users

    before do
        get "/users/sign_in"
        sign_in users(:mark)
    end

    it "creates a Widget and redirects to the Widget's page" do
        get "/"
        expect(response).to render_template("/")
    end
#     post "/widgets", :params => { :widget => {:name => "My Widget"} }

#     expect(response).to redirect_to(assigns(:widget))
#     follow_redirect!

#     expect(response).to render_template(:show)
#     expect(response.body).to include("Widget was successfully created.")
#   end

#   it "does not render a different template" do
#     get "/widgets/new"
#     expect(response).to_not render_template(:show)
#   end
end