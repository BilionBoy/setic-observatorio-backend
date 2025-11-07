class AddProntidaoToAplicacoes < ActiveRecord::Migration[7.2]
  def change
    add_column :aplicacoes, :prontidao_migracao, :integer
    add_column :aplicacoes, :justificativa_prontidao, :text
  end
end
