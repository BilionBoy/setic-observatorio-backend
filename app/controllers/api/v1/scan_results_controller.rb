class Api::V1::ScanResultsController < ApplicationController
  def index
    results = ScanResult
      .includes(:aplicacao)
      .order(id: :asc)

    render json: results, each_serializer: ::ScanResultSerializer
  end

  def show
    result = ScanResult.find(params[:id])
    render json: result, serializer: ::ScanResultSerializer
  end
end
