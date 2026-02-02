class Servidor < ApplicationRecord
  belongs_to :lotacao

  validates :matricula,         presence: true
  validates :nome,              presence: true
  validates :quantidade_erros,  presence: true
end
