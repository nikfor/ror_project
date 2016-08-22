class FixForQuestions < ActiveRecord::Migration[5.0]
  def change
    remove_column :questions, :user_id
    add_reference :questions, :user, index: true, foreign_key: true
  end
end
