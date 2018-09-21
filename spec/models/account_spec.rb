require 'rails_helper'

describe Account do
  describe 'validations' do
    it { should validate_presence_of :user_id }
  end
end
