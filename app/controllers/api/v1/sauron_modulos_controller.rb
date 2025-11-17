module Api
  module V1
    class SauronModulosController < ApplicationController
      before_action :set_modulo, only: [ :show, :dependencias ]

      # GET /api/v1/sauron_modulos
      def index
        mods = SauronModulo.all

        # filtros
        mods = mods.where(linguagem: params[:linguagem]) if params[:linguagem].present?
        mods = mods.where(tipo_projeto: params[:tipo]) if params[:tipo].present?
        mods = mods.where(usa_identityserver: true) if params[:identityserver] == "true"
        mods = mods.where(usa_ldap: true) if params[:ldap] == "true"
        mods = mods.where(usa_jwt_manual: true) if params[:jwt_manual] == "true"

        # busca
        if params[:search].present?
          q = "%#{params[:search].downcase}%"
          mods = mods.where("LOWER(nome) LIKE ?", q)
        end

        # ordenação
        if params[:ordenar_por].present?
          ordem = params[:ordem].presence_in(%w[asc desc]) || "asc"
          mods = mods.order("#{params[:ordenar_por]} #{ordem}")
        else
          mods = mods.order(nome: :asc)
        end

        render json: mods.as_json(
          only: [
            :id, :nome, :linguagem, :versao_dotnet, :tipo_projeto,
            :ef_core, :ef_core_versao, :pacotes_nuget_qtd, :impacto
          ]
        )
      end

      # GET /api/v1/sauron_modulos/:id
      def show
        render json: @modulo.as_json(
          except: [ :created_at, :updated_at ],
          include: {
            dependencias_internas: {
              only: [ :nome, :versao, :critica ]
            }
          }
        )
      end

      # GET /api/v1/sauron_modulos/:id/dependencias
      def dependencias
        render json: @modulo.dependencias_internas.as_json(
          only: [ :nome, :versao, :critica ]
        )
      end

      # GET /api/v1/sauron_modulos/estatisticas
      def estatisticas
        dados = {
          total_modulos: SauronModulo.count,
          por_tipo: SauronModulo.group(:tipo_projeto).count,
          por_linguagem: SauronModulo.group(:linguagem).count,
          por_dotnet: SauronModulo.group(:versao_dotnet).count,
          usa_identityserver: SauronModulo.where(usa_identityserver: true).count,
          usa_ldap: SauronModulo.where(usa_ldap: true).count,
          usa_jwt_manual: SauronModulo.where(usa_jwt_manual: true).count,
          com_ef_core: SauronModulo.where(ef_core: true).count,
          com_migrations: SauronModulo.where(possui_migrations: true).count,
          dependencias_criticas: DependenciaInterna.where(critica: true).count
        }
        render json: dados
      end

      # GET /api/v1/sauron_modulos/riscos
      def riscos
        dados = {
          alto: SauronModulo.where(impacto: "Alto").count,
          medio: SauronModulo.where(impacto: "Médio").count,
          baixo: SauronModulo.where(impacto: "Baixo").count
        }
        render json: dados
      end

      # GET /api/v1/sauron_modulos/dependencias_criticas
      def dependencias_criticas
        criticas = DependenciaInterna.where(critica: true).includes(:sauron_modulo)

        render json: criticas.map { |dep|
          {
            nome: dep.nome,
            versao: dep.versao,
            modulo: dep.sauron_modulo.nome,
            modulo_id: dep.sauron_modulo.id
          }
        }
      end

      private

      def set_modulo
        @modulo = SauronModulo.find(params[:id])
      end
    end
  end
end
