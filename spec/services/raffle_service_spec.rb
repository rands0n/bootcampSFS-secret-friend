require 'rails_helper'

describe RaffleService, type: :service do
  before :each do
    @campaign = create(:campaign, status: :pending)
  end

  describe '#call' do
    context 'when has more then two members' do
      before :each do
        (1..3).each do
          create(:member, campaign: @campaign)
        end
        @campaign.reload

        @results = RaffleService.new(@campaign).call
      end

      it 'results is a hash' do
        expect(@results).to be_a Hash
      end

      it 'all members are in results as a member' do
        result_friends = @results.map {|r| r.last }

        expect(result_friends.sort).to eq @campaign.members.sort
      end

      it 'a member don\'t get yourself' do
        @results.each do |r|
          expect(r.first).not_to eq r.last
        end
      end

      it 'a member x don\'t get a member y that get the member x' do
        # challenge
      end
    end

    context 'when don\'t has more than two members' do
      before :each do
        create(:member, campaign: @campaign)
        @campaign.reload

        @response = RaffleService.new(@campaign).call
      end

      it 'raise error' do
        expect(@response).to eql false
      end
    end
  end
end
