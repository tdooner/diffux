require 'spec_helper'

describe SessionsController do
  describe '#logout' do

    subject { delete :logout }

    context 'when logged in' do
      include_context 'logged in as', FactoryGirl.create(:user)

      it 'removes the user_id key from the session' do
        subject
        session[:user_id].should be_nil
      end

      it 'redirects the user home' do
        subject.should redirect_to root_path
      end
    end
  end
end
