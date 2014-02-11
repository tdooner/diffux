class UserAuthCallbacksController < ApplicationController
  def google_oauth2
    auth_data = request.env['omniauth.auth']
    info      = auth_data['info']

    user = User.where(google_uid: auth_data['uid']).first_or_create

    user.update_attributes(
      email: info['email'],
      name: info['name'],
      image_url: info['image'],
    )

    # for now we don't have any use for the user's access_token, but if we want
    # to find/use it later, it's in auth_data['credentials']['token']

    session[:user_id] = user.id

    return redirect_to root_path
  end
end
