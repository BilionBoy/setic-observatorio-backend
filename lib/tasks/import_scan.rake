namespace :scans do
  desc "Importa XLSX de scans e cruza com aplicacoes"
  task import: :environment do
    require "roo"
    require "yaml"

    file_path = Rails.root.join("lib", "planilhas", "scan_result.xlsx")
    abort("Arquivo não encontrado: #{file_path}") unless File.exist?(file_path)

    puts "Lendo arquivo XLSX..."
    xlsx = Roo::Excelx.new(file_path)
    header = xlsx.row(1)

    # Carrega o arquivo de aliases
    alias_file = Rails.root.join("config", "scan_aliases.yml")
    aliases = File.exist?(alias_file) ? YAML.load_file(alias_file) : {}

    puts "Importando registros…"

    created = 0

    (2..xlsx.last_row).each do |i|
      row = Hash[[ header, xlsx.row(i) ].transpose]

      scan_name_raw = row["scan_name"] || row["SCAN_NAME"] || row["Scan Name"]

      # 1️⃣ MATCH POR ALIAS (PRIORITÁRIO)
      mapped_app_name = aliases[scan_name_raw]
      app = nil

      if mapped_app_name.present?
        app = Aplicacao.find_by(nome: mapped_app_name)
      end

      # 2️⃣ MATCH POR NORMALIZAÇÃO (caso não tenha alias)
      if app.nil?
        normalized_scan = NameNormalizer.normalize(scan_name_raw)

        apps = Aplicacao.all.map do |a|
          [ a, NameNormalizer.normalize(a.nome) ]
        end

        matched = apps.find { |a, norm| normalized_scan.include?(norm) || norm.include?(normalized_scan) }
        app = matched&.first
      end

      # 3️⃣ FALLBACK: LIKE no banco
      if app.nil?
        app = Aplicacao.where("LOWER(nome) LIKE ?", "%#{scan_name_raw.downcase}%").first
      end

      # Criação do registro
      ScanResult.create!(
        scan_file: row["scan_file"],
        scan_name: scan_name_raw,

        critical: row["CRITICAL"] || row["critical"],
        high:     row["HIGH"]     || row["high"],
        medium:   row["MEDIUM"]   || row["medium"],
        low:      row["LOW"]      || row["low"],

        cvss_base_score_max:   row["cvss_base_score_max"],
        cvssv3_base_score_max: row["cvssv3_base_score_max"],
        total: row["TOTAL"],

        aplicacao: app,
        aplicacao_nome: app&.nome,
        versao_dotnet: app&.versao_dotnet,
        ef_core: app&.ef_core,
        linguagem: app&.linguagem
      )

      created += 1
    end

    puts "🎉 Importação finalizada! #{created} registros criados."
  end
end
