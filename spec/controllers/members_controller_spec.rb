require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:campaign) { create(:campaign) }
  let(:member) { create(:member, campaign_id: campaign.id) }
  let(:member_attributes) { attributes_for(:member, campaign_id: campaign.id) }

  before :each do
    sign_in user
  end

  describe 'POST #create' do
    context 'when member is saved' do
      it 'redirects to home page' do
        post :create, params: { member: member_attributes }

        expect(response).to redirect_to root_url
      end

      it 'creates a campaign with the right attributes' do
        post :create, params: { member: member_attributes }

        expect(Member.last.name).to be_truthy
        expect(Member.last.email).to be_truthy
      end

      it 'has the associated campaign' do
        post :create, params: { member: member_attributes }

        expect(Member.last.campaign.title).to be_truthy
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      request.env['HTTP_ACCEPT'] = 'application/json'
    end

    it 'returns http success' do
      delete :destroy, params: { id: member.id }

      expect(response).to have_http_status :success
    end
  end

  describe 'PUT #update' do
    context 'when updating the member' do
      it 'returns http success' do
        put :update, params: { id: member.id, member: member_attributes }

        expect(response).to have_http_status :success
      end

      it 'then the attributes should be changed' do
        put :update, params: { id: member.id, member: member_attributes }

        expect(member.name).to be_truthy
      end
    end
  end
end
