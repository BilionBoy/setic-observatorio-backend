module Api
  module V1
    class AplicacoesController < ApplicationController
      before_action :set_aplicacao, only: [ :show ]

      # GET /api/v1/aplicacoes
      def index
        apps = Aplicacao.all

        # filtros
        apps = apps.where(risco: params[:risco]) if params[:risco].present?
        apps = apps.where(linguagem: params[:linguagem]) if params[:linguagem].present?
        apps = apps.where("prontidao_migracao >= ?", params[:min_prontidao]) if params[:min_prontidao].present?
        apps = apps.where(usa_sauron: true) if params[:usa_sauron].to_s.downcase == "true"
        apps = apps.where(usa_jwt_manual: true) if params[:usa_jwt_manual].to_s.downcase == "true"

        # ordenação
        if params[:ordenar_por].present?
          ordem = params[:ordem].presence_in(%w[asc desc]) || "desc"
          apps = apps.order("#{params[:ordenar_por]} #{ordem}")
        else
          apps = apps.order(prontidao_migracao: :desc)
        end

        render json: apps.limit(params[:limite].presence || 500).as_json(
          only: [ :id, :nome, :risco, :linguagem, :versao_dotnet, :prontidao_migracao, :acao ],
          methods: [ :justificativa_prontidao ]
        )
      end

      # GET /api/v1/aplicacoes/:id
      def show
        render json: @aplicacao.as_json(
          include: {
            dependencias: { only: [ :nome, :versao, :critica ] }
          },
          except: [ :created_at, :updated_at ]
        )
      end

      # GET /api/v1/aplicacoes/estatisticas
      def estatisticas
        dados = {
          total_aplicacoes: Aplicacao.count,
          por_risco: Aplicacao.group(:risco).count,
          por_linguagem: Aplicacao.group(:linguagem).count,
          por_dotnet: Aplicacao.group(:versao_dotnet).count,
          media_prontidao: Aplicacao.average(:prontidao_migracao).to_f.round(2),
          total_criticas: Aplicacao.where(risco: "Crítico").count,
          usa_jwt_manual: Aplicacao.where(usa_jwt_manual: true).count,
          usa_sauron: Aplicacao.where(usa_sauron: true).count
        }
        render json: dados
      end

      # GET /api/v1/aplicacoes/candidatas
      def candidatas
        apps = Aplicacao.order(prontidao_migracao: :desc).limit(params[:limite].presence || 50)
        render json: apps.as_json(
          only: [ :id, :nome, :linguagem, :versao_dotnet, :prontidao_migracao, :acao, :risco ]
        )
      end

      private

      def set_aplicacao
        @aplicacao = Aplicacao.find(params[:id])
      end
    end
  end
end
