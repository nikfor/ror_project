class Question < ApplicationRecord
	has_many :answers, dependent: :destroy
	validates :title, :body, :user_id, presence: true
	validates :title, length: { maximum: 100 }

end
