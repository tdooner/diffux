shared_context 'logged in as' do |user|
  before do
    session[:user_id] = user.id
  end
end
