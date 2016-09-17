FactoryGirl.define do
  factory :attachment do
    #file "MyString"
    file File.open(Rails.root.join('spec/spec_helper.rb'), 'r')
  end
end
