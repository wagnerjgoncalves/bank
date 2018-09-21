# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "jhondoe#{n}@example.com" }
    name { 'Jhon Doe' }
  end
end
