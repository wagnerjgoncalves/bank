# frozen_string_literal: true

require 'rails_helper'

describe Account do
  describe 'associations' do
    it { should belong_to(:user) }

    it { should have_many(:transactions) }
  end

  describe 'validations' do
    it { should validate_presence_of :user_id }
  end
end
