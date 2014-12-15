require 'rails_helper'
require 'evaluation_emailer'

describe EvaluationEmailer do
  describe '.self_evaluation_invite' do
    context 'when it successfully sends' do
      it "returns 'sent' as a status message" do
        participant = create(:participant_with_self_eval) 
        expect(EvaluationEmailer.self_evaluation_invite(participant)).to eq 1
      end
    end
  end

  describe '.send_peer_invites' do
    context 'when it successfully sends' do
      it 'returns a count for number of messages sent' do
        participant = create(:participant_with_peer_evaluation)
        evaluations = Array.new(participant.evaluations)
        expect(EvaluationEmailer.send_peer_invites(evaluations)).to eq 1 
      end
    end
  end

  describe '.send_peer_reminders' do
    context 'when it successfully sends' do
      it 'returns a count for number of messages sent' do
        participant = create(:participant_with_peer_evaluation)
        expect(EvaluationEmailer.send_peer_reminders(participant, "Please complete")).to eq 1
      end
    end
  end
end
