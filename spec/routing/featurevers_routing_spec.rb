require "spec_helper"

describe FeatureversController do
  describe "routing" do

    it "routes to #index" do
      get("/featurevers").should route_to("featurevers#index")
    end

    it "routes to #new" do
      get("/featurevers/new").should route_to("featurevers#new")
    end

    it "routes to #show" do
      get("/featurevers/1").should route_to("featurevers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/featurevers/1/edit").should route_to("featurevers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/featurevers").should route_to("featurevers#create")
    end

    it "routes to #update" do
      put("/featurevers/1").should route_to("featurevers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/featurevers/1").should route_to("featurevers#destroy", :id => "1")
    end

  end
end
