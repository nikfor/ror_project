FactoryGirl.define do
  factory :question do
  	title "title1"
  	body "Question text"
  	association(:answer)
  	end
end
