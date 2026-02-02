class CreateLotacoes < ActiveRecord::Migration[7.2]
  def up
    unless table_exists?(:lotacoes)
      create_table :lotacoes do |t|
      t.string :nome
      t.timestamps
      end
     add_index :lotacoes, :nome, unique: true
    end
  end

  def down
    drop_table :lotacoes if table_exists?(:lotacoes)
  end
end
