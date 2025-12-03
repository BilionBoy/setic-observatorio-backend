class AplicacaoDependencia < ApplicationRecord
  belongs_to :aplicacao
  belongs_to :dependente, class_name: "Aplicacao"

  validates :aplicacao_id, presence: true
  validates :dependente_id, presence: true

  # Evita relacionamento consigo mesmo (cartadeservicosapi → cartadeservicosapi)
  validate :nao_pode_depen_der_de_si_mesma

  private

  def nao_pode_depen_der_de_si_mesma
    if aplicacao_id == dependente_id
      errors.add(:dependente_id, "não pode depender de si mesma")
    end
  end
end
