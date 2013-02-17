# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feed do
    doc_id 1
    feature_id 1
    user_id 1
    message "MyText"
  end
end
