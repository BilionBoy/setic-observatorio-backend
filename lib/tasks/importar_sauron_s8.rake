namespace :observatorio do
  desc "Importa a planilha s8 interna do SAURON"
  task :importar_s8_catalogo, [ :arquivo ] => :environment do |_, args|
    require "roo"

    # ----------------------------
    # HELPERS SEGUROS
    # ----------------------------

    def safe_text(value)
      return nil if value.nil?
      v = value.to_s.strip
      return nil if v == "" || v == "-" || v.downcase.in?(%w[nenhum nenhuma])
      v
    end

    def safe_bool(value)
      return false if value.nil?
      v = value.to_s.strip.downcase
      return true if %w[sim yes y true 1].include?(v)
      return false if %w[não nao no n false 0 - ""].include?(v)
      false
    end

    def safe_array(value)
      return [] if value.nil?
      v = value.to_s.strip
      return [] if v == "" || v == "-" || v.downcase.in?(%w[nenhum nenhuma])
      v.split(",").map(&:strip)
    end

    # ----------------------------
    # CARREGAMENTO DA PLANILHA
    # ----------------------------

    arquivo = args[:arquivo] || "lib/planilhas/sauron_catalogo_s8.xlsx"
    abort "Arquivo inexistente: #{arquivo}" unless File.exist?(arquivo)

    xlsx = Roo::Spreadsheet.open(arquivo)
    sheet = xlsx.sheet(0)

    headers = sheet.row(1).map(&:to_s)
    total = sheet.last_row - 1
    puts "📘 Importando #{total} módulos internos do SAURON..."

    # ----------------------------
    # LOOP DE IMPORTAÇÃO
    # ----------------------------

    (2..sheet.last_row).each do |i|
      row = Hash[[ headers, sheet.row(i) ].transpose]

      mod = SauronModulo.find_or_initialize_by(nome: safe_text(row["Nome"]))

      mod.assign_attributes(
        linguagem:                       safe_text(row["Linguagem"]),
        versao_dotnet:                   safe_text(row["Versao_DotNet"]),
        tipo_projeto:                    safe_text(row["Tipo_Projeto"]),
        ef_core:                         safe_bool(row["EF_Core"]),
        ef_core_versao:                  safe_text(row["EF_Core_Versao"]),
        pacotes_nuget_lista:             safe_text(row["Pacotes_NuGet_Lista"]),
        pacotes_nuget_qtd:               row["Pacotes_NuGet_Qtd"].to_i,
        referencias_internas:            safe_array(row["Referencias_Internas"]),
        usa_identityserver:              safe_bool(row["Usa_IdentityServer"]),
        usa_ldap:                        safe_bool(row["Usa_LDAP"]),
        usa_jwt_manual:                  safe_bool(row["Usa_JWT_Manual"]),
        tipo_banco:                      safe_text(row["Tipo_Banco"]),
        possui_migrations:               safe_bool(row["Possui_Migrations"]),
        qtde_migrations:                 row["Qtde_Migrations"].to_i,
        connectionstring_nomes:          safe_text(row["ConnectionString_Nomes"]),
        connectionstring_principal:      safe_text(row["ConnectionString_Principal"]),
        usa_hangfire:                    safe_bool(row["Usa_Hangfire"]),
        usa_quartz:                      safe_bool(row["Usa_Quartz"]),
        usa_backgroundservice:           safe_bool(row["Usa_BackgroundService"]),
        usa_serilog:                     safe_bool(row["Usa_Serilog"]),
        usa_log4net:                     safe_bool(row["Usa_Log4Net"]),
        usa_swagger:                     safe_bool(row["Usa_Swagger"]),
        usa_automapper:                  safe_bool(row["Usa_AutoMapper"]),
        usa_mediatr:                     safe_bool(row["Usa_MediatR"]),
        usa_middleware_custom:           safe_bool(row["Usa_Middleware_Custom"]),
        tem_startup:                     safe_bool(row["Tem_Startup"]),
        usa_program_antigo:              safe_bool(row["Usa_Program_Antigo"]),
        policies:                        safe_array(row["Policies"]),
        controllers:                     safe_array(row["Controllers"]),
        dbcontexts:                      safe_array(row["DbContexts"]),
        services_transient:              row["Services_Transient"].to_i,
        services_scoped:                 row["Services_Scoped"].to_i,
        services_singleton:              row["Services_Singleton"].to_i,
        observacao:                      safe_text(row["Observacao"]),
        acao_recomendada:                safe_text(row["Acao_Recomendada"]),
        impacto:                         safe_text(row["Impacto"])
      )

      mod.save!
      mod.explode_dependencias!

      puts "✔ (#{i - 1}/#{total}) #{mod.nome}"
    rescue => e
      puts "❌ Erro linha #{i}: #{e.class} – #{e.message}"
    end

    puts "✅ Importação do catálogo interno concluída!"
  end
end
