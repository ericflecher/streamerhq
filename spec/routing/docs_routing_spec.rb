require "spec_helper"

describe DocsController do
  describe "routing" do

    it "routes to #index" do
      get("/docs").should route_to("docs#index")
    end

    it "routes to #new" do
      get("/docs/new").should route_to("docs#new")
    end

    it "routes to #show" do
      get("/docs/1").should route_to("docs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/docs/1/edit").should route_to("docs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/docs").should route_to("docs#create")
    end

    it "routes to #update" do
      put("/docs/1").should route_to("docs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/docs/1").should route_to("docs#destroy", :id => "1")
    end

  end
end
