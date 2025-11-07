class Aplicacao < ApplicationRecord
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
end
