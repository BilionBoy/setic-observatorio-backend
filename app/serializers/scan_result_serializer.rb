class ScanResultSerializer < ActiveModel::Serializer
  attributes :id,
             :scan_file, :scan_name,
             :critical, :high, :medium, :low,
             :cvss_base_score_max, :cvssv3_base_score_max,
             :total,
             :aplicacao_id, :aplicacao_nome, :versao_dotnet, :ef_core, :linguagem

  belongs_to :aplicacao, optional: true
end
