FactoryGirl.define do
  factory :question do
  	user
    title "Question title"
    body "Question text"
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end

  factory :question_with_answer, class: "Question" do
    user
    answer
    title "Question title"
    body "Question text"
  end
end
