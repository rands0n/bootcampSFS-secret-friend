class Campaign < ApplicationRecord
  belongs_to :user

  has_many :members, dependent: :destroy

  before_create :set_member
  before_create :set_status

  enum status: [:pending, :finished]

  validates :title, :description, :user, :status, presence: true

  private

  def set_member
    self.members = Member.create(
      name: self.user.name,
      email: self.user.email
    )
  end

  def set_status
    self.status = :pending
  end
end
