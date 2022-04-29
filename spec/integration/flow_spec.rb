require "rails_helper"

RSpec.describe "Huntr App", :type => :request do
    fixtures :users

    before do
        get "/users/sign_in"
        sign_in users(:mark)
        Current.user = users(:mark)

        def create_kanban(user)
            kanban = user.kanbans.build(id:1, name:"My Created Kanban")
            output = kanban.save
            if output
                return kanban
            end
        end

        def create_kanban_column(kanban)
            kanban_column = kanban.kanban_columns.build(id:1, name: "APPLIED")
            output = kanban_column.save
            if output
                return kanban_column
            end
        end

        def create_card(kanban_column)
            card = kanban_column.cards.build(id: 10, job_title: "Engineer", position: 1, company: "Avion") 
            output = card.save
            if output
                return card
            end
        end

        def create_activity(card)
            activity = card.activities.build(id: 10, title: "My Created Activity", tag: "Apply")
            output = activity.save
            if output
                return activity
            end
        end
    end

    it "should go to kanban index" do
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

    it "should edit kanban" do

        kanban = Current.user.kanbans.build(id:1, name:"My Created Kanban")
        output = kanban.save
        expect(output).to eq(true)

        link = "/kanbans/" + kanban.id.to_s + "/edit"
        expect(link).to eq("/kanbans/1/edit")

        get link
        expect(link).to render_template("kanbans/edit")

        put "/kanbans/" + kanban.id.to_s, :params => {:kanban => {name: "My Edited Kanban"}}
        follow_redirect!
        expect(response.body).to include("My Edited Kanban") 
    end

    it "should delete kanban" do
        kanban = Current.user.kanbans.build(id:1, name:"My Created Kanban")
        output = kanban.save
        expect(output).to eq(true)

        get "/kanbans"
        expect(response.body).to include("My Created Kanban")

        delete "/kanbans/" + kanban.id.to_s
        follow_redirect!
        expect(response.body).to_not include("My Created Kanban") 
    end

   it "should create a card" do
        kanban = create_kanban(Current.user) 
        expect(kanban).to_not eq(nil)
        kanban_column = create_kanban_column(kanban)
        expect(kanban_column).to_not eq(nil)

        get "/kanbans/" + kanban.id.to_s + "/cards/new", :params => {kanban_column_id: kanban_column.id}
        expect(response.body).to include("New Card")

        post "/kanbans/" +  kanban.id.to_s + "/cards", :params => {:card=> {job_title: "Engineer", position: 1, company: "Avion", kanban_column_id: kanban_column.id }} 
        follow_redirect!
        expect(response.body).to include("Engineer")
   end

   it "should edit a card" do
        kanban = create_kanban(Current.user) 
        expect(kanban).to_not eq(nil)
        kanban_column = create_kanban_column(kanban)
        expect(kanban_column).to_not eq(nil)
        card = create_card(kanban_column)
        expect(card).to_not eq(nil)

        get "/kanbans/" + kanban.id.to_s + "/cards/" + card.id.to_s + "/edit", :params => {kanban_column_id: kanban_column.id} 
        expect(response.body).to include("Editing Card")
        expect(response.body).to include(card.job_title)

        put "/kanbans/" + kanban.id.to_s + "/cards/" + card.id.to_s, :params => {:card => {job_title: "Edited Engineer" }} 
        follow_redirect!
        expect(response.body).to include("Edited Engineer")
   end

   it "should delete a card" do
        kanban = create_kanban(Current.user) 
        expect(kanban).to_not eq(nil)
        kanban_column = create_kanban_column(kanban)
        expect(kanban_column).to_not eq(nil)
        card = create_card(kanban_column)
        expect(card).to_not eq(nil)

        get "/kanbans?kanbans_id=" + kanban.id.to_s
        expect(response.body).to include(card.job_title)

        delete "/kanbans/" + kanban.id.to_s + "/cards/" + card.id.to_s
        follow_redirect!
        expect(response.body).to_not include(card.job_title)
   end

   it "should create an activity" do
        kanban = create_kanban(Current.user) 
        expect(kanban).to_not eq(nil)
        kanban_column = create_kanban_column(kanban)
        expect(kanban_column).to_not eq(nil)
        card = create_card(kanban_column)
        expect(card).to_not eq(nil)

        get "/kanbans/" + kanban.id.to_s + "/cards/" + card.id.to_s + "/activities/new", :params => {activity: kanban_column.id} 
        expect(response.body).to include("New Activity")

        post "/kanbans/" +  kanban.id.to_s + "/cards/" + card.id.to_s + "/activities", :params => {:activity=> {title: "Applied Activity", position: 1, tag: "Apply", card_id: card.id}} 
        follow_redirect!
        expect(response.body).to include("Applied Activity") 
    end

    it "should edit an activity" do
        kanban = create_kanban(Current.user) 
        expect(kanban).to_not eq(nil)
        kanban_column = create_kanban_column(kanban)
        expect(kanban_column).to_not eq(nil)
        card = create_card(kanban_column)
        expect(card).to_not eq(nil) 
        activity = create_activity(card)
        expect(activity).to_not eq(nil)

        get "/kanbans/" + kanban.id.to_s + "/cards/" + card.id.to_s + "/activities/" + activity.id.to_s + "/edit", :params => {activity: kanban_column.id} 
        expect(response.body).to include("Editing Activity") 
        expect(response.body).to include(activity.title)

        put "/kanbans/" +  kanban.id.to_s + "/cards/" + card.id.to_s + "/activities/" + activity.id.to_s, :params => {:activity=> {title: "Edited Activity Title"}}
        follow_redirect!
        expect(response.body).to include("Edited Activity Title")  
    end

    it "should delete an activity" do
        kanban = create_kanban(Current.user) 
        expect(kanban).to_not eq(nil)
        kanban_column = create_kanban_column(kanban)
        expect(kanban_column).to_not eq(nil)
        card = create_card(kanban_column)
        expect(card).to_not eq(nil) 
        activity = create_activity(card)
        expect(activity).to_not eq(nil) 

        get "/kanbans/" + kanban.id.to_s + "/cards/" + card.id.to_s + "/edit", :params => {kanban_column_id: kanban_column.id} 
        expect(response.body).to include("Editing Card")
        expect(response.body).to include(activity.title)

        delete "/kanbans/" +  kanban.id.to_s + "/cards/" + card.id.to_s + "/activities/" + activity.id.to_s
        follow_redirect!
        expect(response.body).to_not include(activity.title)
    end
end