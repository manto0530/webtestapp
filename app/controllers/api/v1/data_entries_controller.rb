class Api::V1::DataEntriesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    data_entry = DataEntry.new(data_entry_params)
    if data_entry.save
      notify_third_party_endpoints(data_entry)
      render json: data_entry, status: :created
    else
      render json: { errors: data_entry.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    data_entry = DataEntry.find(params[:id])
    if data_entry.update(data_entry_params)
      notify_third_party_endpoints(data_entry)
      render json: data_entry, status: :ok
    else
      render json: { errors: data_entry.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def data_entry_params
    params.require(:data_entry).permit(:name, :data)
  end

  def notify_third_party_endpoints(data_entry)
	 config_endpoints = Rails.configuration.third_party_endpoints

	 config_endpoints.each do |endpoint|
	    response = HTTParty.post(endpoint, body: data_entry.to_json, headers: { 'Content-Type' => 'application/json' })
	    Rails.logger.info("Notified #{endpoint}: #{response.code}")
	 end
  end
end
