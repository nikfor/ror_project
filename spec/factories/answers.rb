FactoryGirl.define do
  factory :answer do
  	user
    question
  body "MyText"
  end
  factory :invalid_answer, class: "Answer" do
    body nil
  end
end
