class CampaignRaffleJob < ApplicationJob
  queue_as :emails

  def perform(campaign)
    results = RaffleService.new(campaign).call

    campaign.members.each {|m| m.set_pixel }

    results.each do |r|
      CampaignMailer.raffle(campaign, r.first, r.last).deliver_now
    end

    mark_as_finished campaign

    # if results == false
    #   Send mail to owner of campaign
    # end
  end

  private

  def mark_as_finished(campaign)
    campaign.update status: :finished
  end
end
