class CreateAplicacaoDependencias < ActiveRecord::Migration[7.2]
  def change
    unless table_exists?(:aplicacao_dependencias)
      create_table :aplicacao_dependencias do |t|
        t.references :aplicacao, null: false, foreign_key: { to_table: :aplicacoes }
        t.references :dependente, null: false, foreign_key: { to_table: :aplicacoes }
        t.string :origem_tag

        t.timestamps
      end
    end
    unless index_exists?(:aplicacao_dependencias, [ :aplicacao_id, :dependente_id ], name: "idx_app_dep_uniq")
      add_index :aplicacao_dependencias, [ :aplicacao_id, :dependente_id ], unique: true, name: "idx_app_dep_uniq"
    end
  end
end
