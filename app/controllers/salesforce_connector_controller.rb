class SalesforceConnectorController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :check_api_key
  
  def new_participant
    hash = JSON.parse(params[:participant])

    required_keys = ['first_name', 'last_name', 'email',
                     'sf_training_id', 'sf_registration_id', 'sf_contact_id']

    check_for_keys(required_keys, hash); return if performed?
    
    sf_training_id = hash['sf_training_id'] 
    training = Training.find_by(sf_training_id: sf_training_id) 

    render json: 'invalid training record',
      status: 422 and return if training.nil?

    attributes = hash.extract!('first_name', 'last_name', 'email',
                               'sf_registration_id', 'sf_contact_id')

    existing = Participant.where(sf_contact_id: attributes['sf_contact_id'],
                                 sf_registration_id: attributes['sf_registration_id'])
    render json: 'participant already exists',
      status: 200 and return if existing.any?
    
    participant = training.participants.create(attributes)

    if participant && participant.errors.empty?
      participant.invite
      render json: 'success', status: 200 and return
    else
      render json: 'could not create new participant', status: 422
    end
    

  end

  def new_training
    hash = JSON.parse(params[:training])
    required_keys = ['name', 'start_date', 'end_date',
                     'sf_training_id', 'deadline',
                     'questionnaire_name', 'status']

    check_for_keys(required_keys, hash); return if performed? 
    
    if hash['questionnaire_name'] == 'StandaloneCustom'
      questionnaire_name = 'Standalone'
    else
      questionnaire_name = hash['questionnaire_name']
    end

    questionnaire = Questionnaire.find_by(name: questionnaire_name)
    
    if questionnaire
      attributes = hash.extract!('sf_training_id', 'name', 'start_date',
                                 'end_date', 'status', 'city', 'state',
                                 'deadline', 'site_name', 'curriculum')
      attributes['questionnaire_id'] = questionnaire.id
      attributes['no_invite'] = true if hash['questionnaire_name'] == 'StandaloneCustom'
      if Training.create!(attributes)
        render json: 'success', status: 200
      else
        render json: 'could not create new training', status: 422
      end
    else
      render json: 'invalid questionnaire name', status: 422
    end
  end

  def update_participant
    hash = JSON.parse(params[:participant])
    required_keys = ['sf_contact_id', 'changed_fields']

    check_for_keys(required_keys, hash); return if performed? 

    attributes = {}

    participants = Participant.where(sf_contact_id: hash['sf_contact_id'])
    attributes = {}
    approved_fields = ['first_name', 'last_name', 'email',
                               'sf_registration_id', 'sf_contact_id']


    hash['changed_fields'].each do |cf|
      if cf == 'sf_training_id'
        old_training = Training.find_by(sf_training_id: hash['sf_old_training_id'])
        if old_training.nil?
          render json: "could not find salesforce training id #{hash['sf_old_training_id']}",
            status: 422 and return
        end
        participants = old_training.participants.where(sf_contact_id: hash['sf_contact_id'])
        attributes['training_id'] = Training.find_by(sf_training_id: hash['sf_training_id']).id
      elsif approved_fields.include? cf 
        attributes[cf] = hash[cf]
      else
        render json: "#{cf} is not an acceptable changed field", status: 200 and return
      end
    end

    participants.each do |participant|
      if !participant.update!(attributes)
        render json: 'something went wrong', status: 422 and return
      end
    end

    render json: 'success', status: 200
    
  end

  def update_training
    hash = JSON.parse(params[:training])
    required_keys = ['sf_training_id', 'changed_fields']

    check_for_keys(required_keys, hash); return if performed?

    training = Training.find_by(sf_training_id: hash['sf_training_id'])

    render json: 'could not find training',
      status: 422 and return if training.nil?

    attributes = {}
    hash['changed_fields'].each do |cf|
      if cf == 'questionnaire_name'
          if name: hash['questionnaire_name'] == 'Not applicable'
            attributes[cf] = hash[cf]
          end
          attributes['questionnaire_id'] = Questionnaire.find_by(name: hash['questionnaire_name']).id
      else
        attributes[cf] = hash[cf]
      end
    end

    if training.update!(attributes)
      render json: 'success', status: 200
    else
      render json: 'something went wrong', status: 422
    end
    
  end

  private

  def check_for_keys required_keys, hash
    required_keys.each do |key|
      if !hash.has_key?(key) || hash[key].blank?
        render json: "missing required key #{key}", status: 422 and return
      end
    end
  end

  def check_api_key
    puts params
    hash = params.has_key?(:participant) ?
      JSON.parse(params[:participant]) :
      JSON.parse(params[:training])

    if hash.has_key? 'api_key'
      render json: 'unauthorized access',
        status: 422 if hash['api_key'] != ENV['INBOUND_SALESFORCE_KEY']
    else
      render json: 'api key missing', status: 422
    end
  end

end
