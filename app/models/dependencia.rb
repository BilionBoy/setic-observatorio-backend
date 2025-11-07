class Dependencia < ApplicationRecord
  belongs_to :aplicacao

  scope :criticas, -> { where(critica: true) }
  scope :por_gerenciador, ->(g) { where(gerenciador: g) }

  def self.pacotes_criticos_padrao
    [
      "RestSharp",
      "Novell.Directory.Ldap",
      "System.IdentityModel.Tokens.Jwt",
      "Portable.BouncyCastle"
    ]
  end
end
