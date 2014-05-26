class WelcomeController < ApplicationController

  before_filter :redirect_to_my_top

  def index
  end

  private

    def redirect_to_my_top
      redirect_to my_path if user_signed_in?
    end

end
