namespace :observatorio do
  desc "Calcula prontidão de migração (.NET 8 / Duende 6) para todas as aplicações"
  task calcular_prontidao: :environment do
    puts "🧠 Calculando prontidão técnica de migração..."
    total = Aplicacao.count

    Aplicacao.find_each.with_index(1) do |app, idx|
      score = 300
      motivos = []

      # .NET
      if app.versao_dotnet.present?
        case app.versao_dotnet
        when /netcoreapp2|netcoreapp3/
          score -= 40
          motivos << ".NET desatualizado (#{app.versao_dotnet})"
        when /net5/
          score -= 30
          motivos << ".NET 5 - fora de suporte"
        when /net6/
          score -= 10
          motivos << ".NET 6 - próxima LTS (ok)"
        when /net7/
          score -= 5
          motivos << ".NET 7 - próxima LTS"
        when /net8/
          motivos << ".NET 8 - atual (ótimo)"
        else
          score -= 15
          motivos << "Versão .NET indefinida"
        end
      else
        score -= 20
        motivos << "Sem versão .NET declarada"
      end

      # EF Core
      if app.ef_core.present? && app.ef_core.match?(/EntityFrameworkCore.*:(2|3|5)\./)
        score -= 15
        motivos << "EF Core antigo (#{app.ef_core})"
      end

      # JWT Manual
      if app.usa_jwt_manual
        score -= 25
        motivos << "Autenticação JWT manual"
      end

      # Pacotes críticos
      if app.dependencias.where(critica: true).exists?
        score -= 15
        motivos << "Possui pacotes críticos (RestSharp, Novell, JWT)"
      end

      # Risco
      case app.risco
      when "Crítico" then score -= 20
      when "Médio"   then score -= 10
      end

      # Garantir faixa de 0..100
      score = [ [ score, 0 ].max, 300 ].min

      app.update!(
        prontidao_migracao: score,
        justificativa_prontidao: motivos.join("; ")
      )

      puts "✔️ (#{idx}/#{total}) #{app.nome}: #{score} pontos"
    end

    puts "✅ Cálculo de prontidão concluído!"
  end
end
