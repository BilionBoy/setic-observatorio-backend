class ScanResult < ApplicationRecord
  belongs_to :aplicacao, optional: true

  validates :scan_name, presence: true
end
