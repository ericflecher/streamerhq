# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :featurever do
    title "MyString"
    gherkin "MyText"
    photo_file_name "MyString"
    photo_content_type "MyString"
    photo_file_size 1
    photo_updated_at "2012-12-29 16:43:49"
  end
end
