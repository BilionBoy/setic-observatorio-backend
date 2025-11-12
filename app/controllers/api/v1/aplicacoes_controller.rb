module Api
  module V1
    class AplicacoesController < ApplicationController
      include Pagy::Backend
      include JsonResponse
      include PagyPagination

      before_action :set_aplicacao, only: [ :show ]

      # GET /api/v1/aplicacoes
      def index
        query = Aplicacao.ransack(params[:q])
        apps = query.result(distinct: true)

        # Ordenação padrão
        apps = apps.order(prontidao_migracao: :desc) if params[:ordenar_por].blank?

        # Paginação e formatação padronizada
        response = paginate(apps, params[:per_page] || 300)

        render_success(
          data: {
            pagination: response[:pagy],
            items: response[:items].as_json(
              only: [
                :id, :nome, :risco, :linguagem,
                :versao_dotnet, :ef_core,
                :prontidao_migracao, :pacotes_nuget, :acao
              ],
              methods: [ :justificativa_prontidao ]
            )
          },
          message: "Aplicações listadas com sucesso"
        )
      end

      # GET /api/v1/aplicacoes/:id
      def show
        render_success(
          data: @aplicacao.as_json(
            include: { dependencias: { only: [ :nome, :versao, :critica ] } },
            except: [ :created_at, :updated_at ]
          ),
          message: "Aplicação carregada com sucesso"
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

        render_success(data: dados, message: "Estatísticas consolidadas com sucesso")
      end

      # GET /api/v1/aplicacoes/candidatas
      def candidatas
        apps = Aplicacao.order(prontidao_migracao: :desc)
        response = paginate(apps, params[:limite] || 50)

        render_success(
          data: {
            pagination: response[:pagy],
            items: response[:items].as_json(
              only: [
                :id, :nome, :linguagem, :versao_dotnet,
                :ef_core, :prontidao_migracao, :acao, :pacotes_nuget, :risco
              ]
            )
          },
          message: "Aplicações candidatas listadas com sucesso"
        )
      end

      private

      def set_aplicacao
        @aplicacao = Aplicacao.find(params[:id])
      end
    end
  end
end
