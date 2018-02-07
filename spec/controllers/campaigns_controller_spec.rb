require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @current_user = FactoryBot.create(:user)
    sign_in @current_user
  end

  describe 'GET #show' do
    context 'campaign exists' do
      context 'user is the owner of the campaign' do
        it 'returns success' do
          campaign = create(:campaign, user: @current_user)
          get :show, params: { id: campaign.id }

          expect(response).to have_http_status :success
        end
      end

      context 'user is not owner of the campaign' do
        it 'redirect to root path' do
          campaign = create(:campaign, user: @current_user)
          get :show, params: { id: campaign.id }

          expect(response).to have_http_status :success
        end
      end

      context 'campaing does not exist' do
        it 'redirects to the root path' do
          campaign = create(:campaign, user: @current_user)
          get :show, params: { id: 0 }

          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe 'POST #create' do
    before(:each) do
      @campaign_attributes = attributes_for(:campaign, user: @current_user)
      post :create, params: { campaign: @campaign_attributes }
    end

    it 'redirect to new campaign' do
      expect(response).to have_http_status 302
      expect(response).to redirect_to "/campaigns/#{Campaign.last.id}"
    end

    it 'creates a campaign with the right attributes' do
      campaign = Campaign.last

      expect(campaign.user).to eql @current_user
      expect(campaign.title).to eql 'Nova campanha'
      expect(campaign.description).to eql 'Descreva sua campanha...'
      expect(campaign.status).to eql 'pending'
    end

    it 'creates a campaign with owner associated as a member' do
      campaign = Campaign.last

      expect(campaign.members.last.name).to eql @current_user.name
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      request.env['HTTP_ACCEPT'] = 'application/json'
    end

    context 'User is the Campaign Owner' do
      it 'returns http success' do
        campaign = create(:campaign, user: @current_user)
        delete :destroy, params: { id: campaign.id }

        expect(response).to have_http_status :success
      end
    end

    context 'User isn\'t the Campaign Owner' do
      it 'returns http forbidden' do
        campaign = create(:campaign)
        delete :destroy, params: { id: campaign.id }

        expect(response).to have_http_status :forbidden
      end
    end
  end

  describe 'PUT #update' do
    before(:each) do
      @new_campaign_attributes = attributes_for(:campaign)
      request.env['HTTP_ACCEPT'] = 'application/json'
    end

    context 'User is the Campaign Owner' do
      before(:each) do
        campaign = create(:campaign, user: @current_user)
        put :update, params: { id: campaign.id, campaign: @new_campaign_attributes }
      end

      it 'returns http success' do
        expect(response).to have_http_status :success
      end

      it 'Campaign have the new attributes' do
        campaign = Campaign.last

        expect(campaign.title).to eq @new_campaign_attributes[:title]
        expect(campaign.description).to eq @new_campaign_attributes[:description]
      end
    end

    context 'User isn\'t the Campaign Owner' do
      it 'returns http forbidden' do
        campaign = create(:campaign)
        put :update, params: { id: campaign.id, campaign: @new_campaign_attributes }

        expect(response).to have_http_status :forbidden
      end
    end
  end

  describe 'GET #raffle' do
    before(:each) do
      request.env['HTTP_ACCEPT'] = 'application/json'
    end

    context 'User is the Campaign Owner' do
      before(:each) do
        @campaign = create(:campaign, user: @current_user)
      end

      context 'Has more than two members' do
        before(:each) do
          (1..3).each do
            create(:member, campaign: @campaign)
          end

          post :raffle, params: { id: @campaign.id }
        end
      end

      context 'No more than two members' do
        before(:each) do
          create(:member, campaign: @campaign)
          post :raffle, params: { id: @campaign.id }
        end

        it 'returns http success' do
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context 'User isn\'t the Campaign Owner' do
      before(:each) do
        @campaign = create(:campaign)
        post :raffle, params: { id: @campaign.id }
      end

      it 'returns http forbidden' do
        expect(response).to have_http_status :forbidden
      end
    end
  end
end
