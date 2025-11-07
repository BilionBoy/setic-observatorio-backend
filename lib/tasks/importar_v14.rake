# lib/tasks/importar_v14.rake
namespace :observatorio do
  desc "Importa planilha Excel V14 (inventario_v14.xlsx) para a tabela aplicacoes"
  task :importar_v14, [ :arquivo ] => :environment do |_, args|
    require "roo"

    arquivo = args[:arquivo]
    abort "Informe o caminho da planilha: rake 'observatorio:importar_v14[caminho.xlsx]'" unless arquivo

    puts "📊 Lendo planilha: #{arquivo}"
    xlsx = Roo::Spreadsheet.open(arquivo)
    sheet = xlsx.sheet(0)

    headers = sheet.row(1).map(&:to_s)

    puts "🧠 Colunas detectadas: #{headers.join(', ')}"
    total = sheet.last_row - 1
    puts "📄 Linhas encontradas: #{total}"

    (2..sheet.last_row).each do |i|
      row = Hash[[ headers, sheet.row(i) ].transpose]

      app = Aplicacao.find_or_initialize_by(nome: row["Nome"])

      app.assign_attributes(
        versao_dotnet: row["Versao_DotNet"],
        ef_core: row["EF_Core"],
        problema_detalhado: row["Problema_Detalhado"],
        observacao: row["Observacao"],
        tipo_authority: row["Tipo_Authority"],
        usa_sauron: row["Usa_Sauron"].to_s.strip.casecmp("Sim").zero?,
        total_dlls: row["Total_DLLs"].to_i,
        acao: row["Acao"],
        authority: row["Authority"],
        restsharp: row["RestSharp"],
        sdk_usado: row["SDK_Usado"],
        pacotes_criticos: row["Pacotes_Criticos"],
        risco: row["Risco"],
        risco_motivo: row["Risco_Motivo"],
        tipo_auth: row["Tipo_Auth"],
        tipo: row["Tipo"],
        impacto_quebra: row["Impacto_Quebra"],
        linguagem: row["Linguagem"],
        total_pacotes: row["Total_Pacotes"].to_i,
        recomendacao_detalhada: row["Recomendacao_Detalhada"],
        pacotes_nuget: row["Pacotes_NuGet"],
        usa_jwt_manual: row["Usa_JWT_Manual"].to_s.strip.casecmp("Sim").zero?
      )

      app.save!
      puts "✔️  (#{i - 1}/#{total}) #{app.nome}"
    rescue => e
      puts "❌ Erro ao importar linha #{i}: #{e.message}"
    end

    puts "✅ Importação concluída com sucesso!"
  end
end
