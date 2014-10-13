require 'rails_helper'

RSpec.describe Participant, :type => :model do

  expect_it { to validate_presence_of :email }
  expect_it { to have_many :evaluations }

  describe '#self_evaluation' do
    it 'returns the self evaluation' do
      participant = create(:participant_with_self_eval)
      self_evaluation = participant.self_evaluation
      expect(self_evaluation.evaluator_id).to eq participant.id
    end
  end

end
