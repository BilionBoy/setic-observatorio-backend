class CreateSauronModulos < ActiveRecord::Migration[7.2]
  def change
    create_table :sauron_modulos do |t|
      t.string :nome
      t.string :linguagem
      t.string :versao_dotnet
      t.string :tipo_projeto
      t.boolean :ef_core
      t.string :ef_core_versao
      t.text :pacotes_nuget_lista
      t.integer :pacotes_nuget_qtd
      t.text :referencias_internas
      t.boolean :usa_identityserver
      t.boolean :usa_ldap
      t.boolean :usa_jwt_manual
      t.string :tipo_banco
      t.boolean :possui_migrations
      t.integer :qtde_migrations
      t.text :connectionstring_nomes
      t.string :connectionstring_principal
      t.boolean :usa_hangfire
      t.boolean :usa_quartz
      t.boolean :usa_backgroundservice
      t.boolean :usa_serilog
      t.boolean :usa_log4net
      t.boolean :usa_swagger
      t.boolean :usa_automapper
      t.boolean :usa_mediatr
      t.boolean :usa_middleware_custom
      t.boolean :tem_startup
      t.boolean :usa_program_antigo
      t.text :policies
      t.text :controllers
      t.text :dbcontexts
      t.integer :services_transient
      t.integer :services_scoped
      t.integer :services_singleton
      t.text :observacao
      t.text :acao_recomendada
      t.string :impacto

      t.timestamps
    end
  end
end
