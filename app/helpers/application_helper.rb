module ApplicationHelper
  # @param [String]
  # @return [String]
  def simplified_url(url)
    url.gsub(%r[(?:\Ahttp://|/\Z)], '')
  end

  # @return [User] the logged in user, or nil
  def current_user
    return unless session[:user_id]

    @logged_in_user ||= User.find(session[:user_id])
  end
end
