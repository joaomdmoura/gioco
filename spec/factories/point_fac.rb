FactoryGirl.define do
  factory :point do
    value  100
    association :type, :factory => :type
  end
end