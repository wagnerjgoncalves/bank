# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    trait :debit do
      kind { :debit }
    end

    trait :credit do
      kind { :credit }
    end
  end
end
