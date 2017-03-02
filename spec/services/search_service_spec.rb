require 'rails_helper'

RSpec.describe Search do

  describe 'do search' do
    it 'runs with valid' do
      expect(Search).to receive(:run).with('question', 'question', 0)
      Search.run('question', 'question', 0)
    end

    it 'runs with invalid' do
      expect(Search.run('question', 'question', 0)).to eq []
    end
  end
end
