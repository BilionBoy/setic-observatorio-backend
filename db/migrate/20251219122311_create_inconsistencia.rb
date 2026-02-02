class CreateInconsistencia < ActiveRecord::Migration[7.2]
  def change
    create_table :inconsistencia do |t|
      t.references :servidor, null: false, foreign_key: true
      t.string :sistema
      t.string :campo
      t.string :raw_key
      t.string :contexto
      t.text :mensagem

      t.timestamps
    end
  end
end
