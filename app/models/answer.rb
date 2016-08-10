class Answer < ApplicationRecord
	belongs_to :question
	validates :body, :question, :user_id, presence: true
end
