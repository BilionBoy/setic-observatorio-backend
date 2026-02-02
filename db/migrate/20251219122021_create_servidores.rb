class CreateServidores < ActiveRecord::Migration[7.2]
  def up
    unless table_exists?(:servidores)
      create_table :servidores do |t|
      t.string     :matricula
      t.string     :nome
      t.integer    :quantidade_erros
      t.references :lotacao, null: false, foreign_key: true
      t.timestamps
      end
     add_index :servidores, :matricula, unique: true
    end
  end

  def down
    drop_table :servidores if table_exists?(:servidores)
  end
end
