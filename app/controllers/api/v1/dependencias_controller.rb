module Api
  module V1
    class DependenciasController < ApplicationController
      # GET /api/v1/dependencias?nome=RestSharp
      def index
        deps = Dependencia.all
        deps = deps.where("LOWER(nome) LIKE ?", "%#{params[:nome].downcase}%") if params[:nome].present?

        render json: deps.limit(500).as_json(
          include: {
            aplicacao: { only: [ :id, :nome, :linguagem, :versao_dotnet, :prontidao_migracao ] }
          },
          only: [ :nome, :versao, :critica ]
        )
      end
    end
  end
end
