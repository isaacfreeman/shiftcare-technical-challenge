class ClientsController < ApplicationController
  def find_matches
    data_path = "#{Rails.root}/clients.json"
    client_list = ClientList.from_json_file(data_path)

    query = index_params["q"]

    if query.blank?
      render(json: { errors: [ "A query param is required"]}, status: :bad_request) and return
    end

    field = index_params["field"] || :full_name

    matching_clients = client_list.find_matches(regex_query: query, field: field.to_sym)

    render json: matching_clients
  end

  private

  def index_params
    params.permit(:q, :field)
  end
end
