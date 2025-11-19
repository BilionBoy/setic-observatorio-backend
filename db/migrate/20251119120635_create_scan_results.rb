class CreateScanResults < ActiveRecord::Migration[7.2]
  def up
    return if table_exists?(:scan_results)

    create_table :scan_results do |t|
      t.string :scan_file
      t.string :scan_name
      t.integer :critical
      t.integer :high
      t.integer :medium
      t.integer :low
      t.float :cvss_base_score_max
      t.float :cvssv3_base_score_max
      t.integer :total
      t.references :aplicacao, null: true, foreign_key: true
      t.string :aplicacao_nome
      t.string :versao_dotnet
      t.text :ef_core
      t.string :linguagem

      t.timestamps
    end
  end

  def down
    drop_table :scan_results if table_exists?(:scan_results)
  end
end
