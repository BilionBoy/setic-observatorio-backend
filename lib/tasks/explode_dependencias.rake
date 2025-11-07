namespace :observatorio do
  desc "Explode pacotes NuGet da tabela aplicacoes para dependencias"
  task explode_dependencias: :environment do
    total = Aplicacao.count
    puts "🔍 Processando dependências de #{total} aplicações..."

    Aplicacao.find_each.with_index(1) do |app, idx|
      next if app.pacotes_nuget.blank? || app.pacotes_nuget == "-"
      app.dependencias.delete_all
      app.explode_dependencias!
      puts "✔️ (#{idx}/#{total}) #{app.nome} - #{app.dependencias.count} dependências"
    end

    puts "✅ Dependências explodidas e salvas!"
  end
end
