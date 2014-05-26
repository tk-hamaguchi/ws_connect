require 'spec_helper'

describe MyController, :type => :controller do

  describe "GET 'top'" do
    it "returns http success" do
      get 'top'
      expect(response).to be_success
    end
  end

end
