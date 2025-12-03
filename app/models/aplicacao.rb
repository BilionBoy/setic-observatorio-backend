class Aplicacao < ApplicationRecord
  # ============================
  # 1) Dependências técnicas (já existente)
  # ============================
  has_many :dependencias, dependent: :destroy

  def explode_dependencias!
    return if pacotes_nuget.blank? || pacotes_nuget == "-"

    lista = pacotes_nuget.split(";").map(&:strip).reject(&:blank?)
    lista.each do |item|
      nome, versao = item.split(":").map(&:strip)
      proximo = Dependencia.pacotes_criticos_padrao.any? { |c| nome&.include?(c) }

      dependencias.create!(
        gerenciador: "nuget",
        nome: nome.presence || "Desconhecido",
        versao: versao,
        critica: proximo
      )
    end
  end

  # ============================
  # 2) Dependências funcionais (nova planilha 3)
  # ============================
  has_many :aplicacao_dependencias, dependent: :destroy
  has_many :dependencias_funcionais,
           through: :aplicacao_dependencias,
           source: :dependente

  has_many :dependencias_invertidas,
           class_name: "AplicacaoDependencia",
           foreign_key: :dependente_id,
           dependent: :destroy

  has_many :dependentes,
           through: :dependencias_invertidas,
           source: :aplicacao
end
