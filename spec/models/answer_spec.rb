require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id}
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  describe 'check_best' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question, user: user, best: false) }
    let!(:other_answer) { create(:answer, question: question, user: user, best: true) } 

    it 'check best answer' do
      answer.check_best
      answer.reload
      other_answer.reload
      expect(answer.best).to eq true
      expect(other_answer.best).to eq false
    end
  end
end
