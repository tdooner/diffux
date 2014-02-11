require 'spec_helper'

describe UserAuthCallbacksController do
  describe '#google_oauth2' do
    let(:user) { FactoryGirl.build(:user) }
    let(:data) do
      # an excerpt of the real hash returned by omniauth:
      {
        uid: user.google_uid,
        info: {
          name: user.name,
          email: user.email,
          image: user.image_url,
        },
        # unused:
        credentials: {
          token: "abc123",
          expires_at: 1392100972,
          expires: true
        },
      }.with_indifferent_access
    end

    before do
      request.env['omniauth.auth'] = data
    end

    subject { get :google_oauth2 }

    context "when the user hasn't logged in previously" do
      it 'creates the user' do
        expect { subject }
          .to change { User.where(google_uid: user.google_uid).any? }
          .from(false)
          .to(true)
      end

      it 'logs the user in' do
        subject
        session[:user_id].should == User.find_by(google_uid: user.google_uid).id
      end
    end

    context 'when the user has logged in' do
      before do
        user.save
      end

      it 'logs the user in' do
        subject
        session[:user_id].should == user.id
      end
    end
  end
end
