class Answer < ApplicationRecord
	belongs_to :question, dependent: :destroy
	validates :body, :question, :user_id, presence: true
end
