class CreateDependenciasInternas < ActiveRecord::Migration[7.2]
  def change
    create_table :dependencias_internas do |t|
      t.references :sauron_modulo, null: false, foreign_key: true
      t.string :nome
      t.string :versao
      t.boolean :critica

      t.timestamps
    end
  end
end
