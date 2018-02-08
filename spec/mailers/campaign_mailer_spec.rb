require "rails_helper"

RSpec.describe CampaignMailer, type: :mailer do
  describe "raffle" do
    let(:campaign) { create(:campaign) }
    let(:member) { create(:member, campaign: campaign) }
    let(:friend) { create(:user) }
    let(:mail) { CampaignMailer.raffle(campaign, member, friend) }

    it "renders the headers" do
      expect(mail.subject).to be_truthy
      expect(mail.to).to eq([member.email])
    end

    it 'body have member name' do
      expect(mail.body.encoded).to match member.name
    end

    it "body have campaign creator name" do
      expect(mail.body.encoded).to match(campaign.user.name)
    end
  end
end
