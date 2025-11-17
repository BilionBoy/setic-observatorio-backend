class SauronModulo < ApplicationRecord
has_many :dependencias_internas, class_name: "DependenciaInterna"

  # Remover serializations problemáticas
  # serialize :referencias_internas, Array
  # serialize :policies, Array
  # serialize :controllers, Array
  # serialize :dbcontexts, Array

  # Garante que sempre retorna array
  def referencias_internas
    read_attribute(:referencias_internas).presence || []
  end

  def policies
    read_attribute(:policies).presence || []
  end

  def controllers
    read_attribute(:controllers).presence || []
  end

  def dbcontexts
    read_attribute(:dbcontexts).presence || []
  end

  def parse_list(value)
    return [] if value.blank? || value == "-" || value.downcase == "nenhuma" || value.downcase == "nenhum"
    value.split(",").map(&:strip)
  end

  def explode_dependencias!
    dependencias_internas.destroy_all
    return if pacotes_nuget_lista.blank?

    parse_list(pacotes_nuget_lista).each do |item|
      nome, versao = item.split(":").map(&:strip)
      dependencias_internas.create!(
        nome: nome,
        versao: versao,
        critica: DependenciaInterna.pacotes_criticos_padrao.any? { |k| nome&.include?(k) }
      )
    end
  end
end
