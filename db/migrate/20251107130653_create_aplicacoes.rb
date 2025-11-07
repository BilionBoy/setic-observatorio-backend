class CreateAplicacoes < ActiveRecord::Migration[7.2]
  def change
    create_table :aplicacoes do |t|
      t.string :nome
      t.string :versao_dotnet
      t.text :ef_core
      t.text :problema_detalhado
      t.text :observacao
      t.string :tipo_authority
      t.boolean :usa_sauron
      t.integer :total_dlls
      t.string :acao
      t.string :authority
      t.string :restsharp
      t.string :sdk_usado
      t.string :pacotes_criticos
      t.string :risco
      t.text :risco_motivo
      t.string :tipo_auth
      t.string :tipo
      t.string :impacto_quebra
      t.string :linguagem
      t.integer :total_pacotes
      t.text :recomendacao_detalhada
      t.text :pacotes_nuget
      t.boolean :usa_jwt_manual

      t.timestamps
    end
  end
end
