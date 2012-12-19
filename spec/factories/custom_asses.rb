# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :custom_ass do
    user_id 1
    feature_id 1
    doc_id 1
    codetype "MyText"
  end
end
