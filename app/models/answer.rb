class Answer < ApplicationRecord
  belongs_to :question, touch: true
  belongs_to :user
  validates :body, :question_id, :user_id, presence: true

  default_scope { order(best: :desc, created_at: :asc) }

  def check_best
    Answer.transaction  do      
      if self.question.best_answer.present?
        self.question.best_answer.update(best: false)
      end
      self.best = true
      self.save!
    end
  end  
end
