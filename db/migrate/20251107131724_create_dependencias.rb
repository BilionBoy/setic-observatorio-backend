class CreateDependencias < ActiveRecord::Migration[7.2]
  def change
    create_table :dependencias do |t|
      t.references :aplicacao, null: false, foreign_key: true
      t.string :gerenciador
      t.string :nome
      t.string :versao
      t.boolean :critica

      t.timestamps
    end
  end
end
