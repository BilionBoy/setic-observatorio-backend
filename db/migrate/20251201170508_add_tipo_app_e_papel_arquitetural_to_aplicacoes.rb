class AddTipoAppEPapelArquiteturalToAplicacoes < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:aplicacoes, :tipo_app)
      add_column :aplicacoes, :tipo_app, :string
    end

    unless column_exists?(:aplicacoes, :papel_arquitetural)
      add_column :aplicacoes, :papel_arquitetural, :string
    end
  end
end
