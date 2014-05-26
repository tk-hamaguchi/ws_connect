class MyController < ApplicationController
  before_filter :authenticate_user!
  def top
  end
end
