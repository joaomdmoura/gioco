require 'factory_girl'

FactoryGirl.define do
  factory :user do
    name    "John Doe"
    email   "Jonh@doe.com"
  end
end