require 'rails_helper'
require Rails.root.join "spec/models/concerns/votable_spec.rb"

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
  
  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_presence_of :user_id}
    it { should validate_length_of(:title).is_at_most(100) }
  end
  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments) }
  it { should accept_nested_attributes_for :attachments }
end
