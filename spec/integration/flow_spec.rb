require "rails_helper"

RSpec.describe "Kanbans", :type => :request do
    fixtures :users

    before do
        get "/users/sign_in"
        sign_in users(:mark)
    end

    it "should go to home" do
        get "/"
        expect(response).to render_template("/")

        get "/kanbans"
        expect(response.body).to include("My Boards:")
        expect(response).to render_template("kanbans/index")
    end

    it "should create kanban" do
        get "/kanbans/new"
        post "/kanbans" , :params => {:kanban => {name: "My Created Kanban"}}
        follow_redirect!
        expect(response.body).to include("My Created Kanban")
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