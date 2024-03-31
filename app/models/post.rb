class Post < ApplicationRecord
  include AASM

  belongs_to :user
  has_many :attachments

  aasm column: :status do
    state :draft, initial: true
    state :pending
    state :approved
    state :rejected

    event :submit_for_review do
      transitions from: :draft, to: :pending
    end

    event :approve do
      transitions from: :pending, to: :approved
    end

    event :reject do
      transitions from: :pending, to: :rejected
    end
  end
end
