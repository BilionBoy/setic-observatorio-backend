class DependenciaInterna < ApplicationRecord
  self.table_name = "dependencias_internas"

  belongs_to :sauron_modulo

  def self.pacotes_criticos_padrao
    [
      "RestSharp",
      "Novell.Directory.Ldap",
      "System.IdentityModel.Tokens.Jwt",
      "Portable.BouncyCastle"
    ]
  end
end
