class Answer < ApplicationRecord
	belongs_to :question
	validates :answer, :user_id, presence: true
end
