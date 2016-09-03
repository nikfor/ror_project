class Answer < ApplicationRecord
  belongs_to :question, touch: true
  belongs_to :user
  validates :body, :question_id, :user_id, presence: true

  default_scope { order(best: :desc, created_at: :asc) }

  def best!
    Answer.transaction  do      
    self.question.answers.where(best: true).update_all(best: false)
    self.best = true
    self.save!
    end
  end  
end
