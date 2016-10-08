class Question < ApplicationRecord
  include Votable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  belongs_to :user
  has_one :best_answer, -> { where(best: true) }, class_name: Answer
  validates :title, :body, :user_id, presence: true
  validates :title, length: { maximum: 100 }
  accepts_nested_attributes_for :attachments, allow_destroy: true
end
