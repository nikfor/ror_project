class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, optional: true
  
  validates :user_id, :body, presence: true

  default_scope { order(created_at: :asc) }
end
