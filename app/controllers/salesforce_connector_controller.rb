class SalesforceConnectorController < ApplicationController
  protect_from_forgery with: :null_session

  def new_participant
    # if params[:participant] && params[:participant].is_a?(String) 
    #   hash = JSON.parse(params[:participant])

    #   attributes = { first_name: hash['First_Name__c'],
    #                   last_name: hash['Last_Name__c'],
    #                   email: hash['Email__c'] }
    #   participant = Participant.create!(attributes)
    #    
    #   if participant && participant.errors.empty?
    #     #Evaluation.create_self_evaluation(participant)
    #     #EvaluationEmailer.send_invite_for_self_eval(participant)
    #     render json: 'success', status: 200 and return
    #   end
    # end

    # render json: 'something went wrong', status: 422
    puts "****new_participant"
    puts params

    render json: 'success', status: 200
  end

  def new_training
    puts "***new_training"
    puts params
    render json: 'success', status: 200
  end

  def update_participant
    puts "***update_participant"
    puts params
    render json: 'success', status: 200
  end

  def update_training
    puts "****update_training"
    puts params
    render json: 'success', status: 200
  end

  

end
