class SessionsController < ApplicationController
  def logout
    session.delete(:user_id)

    redirect_to root_path
  end
end
