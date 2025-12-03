# lib/tasks/inventario_arquitetura.rake
require "roo"

namespace :inventario do
  desc "Importa arquitetura funcional (planilha 3): tipo_app, papel_arquitetural e dependências entre aplicações (com normalização inteligente)"
  task importar_arquitetura: :environment do
    arquivo = Rails.root.join("lib", "planilhas", "inventario_v18_v1.xlsx")

    unless File.exist?(arquivo)
      puts "[ERRO] Arquivo não encontrado: #{arquivo}"
      exit 1
    end

    puts "=========================================="
    puts "[INFO] Importação da Arquitetura (Etapa 3)"
    puts "[INFO] Usando normalização inteligente de nomes"
    puts "=========================================="

    xlsx  = Roo::Spreadsheet.open(arquivo.to_s)
    sheet = xlsx.sheet(0)

    header = sheet.row(1).map { |h| h.to_s.strip.downcase }

    # mapeamento
    idx_app                = header.index("app")
    idx_tipo_app           = header.index("tipo_app")
    idx_papel_arquitetural = header.index("papel_arquitetural")
    idx_depende_de         = header.index("depende_de")

    if [ idx_app, idx_tipo_app, idx_papel_arquitetural, idx_depende_de ].any?(&:nil?)
      puts "[ERRO] Cabeçalhos inválidos!"
      puts "Esperado: app, tipo_app, papel_arquitetural, depende_de"
      puts "Encontrado: #{header}"
      exit 1
    end

    # transformar para 1-based index
    idx_app += 1
    idx_tipo_app += 1
    idx_papel_arquitetural += 1
    idx_depende_de += 1

    puts "[INFO] Linhas detectadas: #{sheet.last_row - 1}"

    # ===========
    # NORMALIZAÇÃO
    # ===========
    def normalizar_nome(nome)
      nome.to_s.downcase.strip
          .gsub(/[^a-z0-9]/, "")  # remove tudo exceto letras e numeros
    end

    # Mapa de lookup rápido (normalizado → objeto aplicação)
    mapa_apps = {}
    Aplicacao.find_each do |app|
      mapa_apps[normalizar_nome(app.nome)] = app
    end

    puts "[INFO] Aplicações carregadas na memória: #{mapa_apps.size}"

    # limpar dependências antes de recriar
    puts "[INFO] Limpando dependências funcionais..."
    AplicacaoDependencia.delete_all

    faltando_apps_planilha = []
    dependencias_criadas   = 0
    atualizadas            = 0
    tags_sem_app           = Hash.new(0)

    # =====================
    # processamento linha a linha
    # =====================
    (2..sheet.last_row).each do |row_idx|
      linha = sheet.row(row_idx)

      nome_app   = linha[idx_app].to_s.strip
      tipo_app   = linha[idx_tipo_app].to_s.strip
      papel_arq  = linha[idx_papel_arquitetural].to_s.strip
      depende_de = linha[idx_depende_de].to_s

      next if nome_app.blank?

      nome_norm = normalizar_nome(nome_app)
      aplicacao = mapa_apps[nome_norm]

      if aplicacao.nil?
        faltando_apps_planilha << nome_app
        next
      end

      # Atualizar tipo_app e papel_arquitetural se mudou
      mudou = false

      if aplicacao.tipo_app != tipo_app
        aplicacao.tipo_app = tipo_app.presence
        mudou = true
      end

      if aplicacao.papel_arquitetural != papel_arq
        aplicacao.papel_arquitetural = papel_arq.presence
        mudou = true
      end

      if mudou
        aplicacao.save!
        atualizadas += 1
      end

      next if depende_de.blank?

      # explode tags
      lista = depende_de.split(",").map(&:strip).reject(&:blank?).uniq

      lista.each do |tag|
        tag_norm = normalizar_nome(tag)

        dependente = mapa_apps[tag_norm]

        if dependente.nil?
          tags_sem_app[tag] += 1
          next
        end

        next if dependente.id == aplicacao.id

        rel = AplicacaoDependencia.find_or_initialize_by(
          aplicacao_id: aplicacao.id,
          dependente_id: dependente.id
        )

        if rel.new_record?
          rel.origem_tag = tag
          rel.save!
          dependencias_criadas += 1
        end
      end
    end

    # ==============
    # RESULTADO FINAL
    # ==============
    puts "=========================================="
    puts "[RESULTADOS]"
    puts "Aplicações atualizadas...........: #{atualizadas}"
    puts "Dependências criadas.............: #{dependencias_criadas}"
    puts "------------------------------------------"

    if faltando_apps_planilha.any?
      puts "[AVISO] Apps da planilha não encontradas no banco:"
      puts faltando_apps_planilha.uniq.sort.join(", ")
    end

    if tags_sem_app.any?
      puts "[AVISO] Tags sem aplicação correspondente:"
      tags_sem_app.sort_by { |_, q| -q }.each do |tag, qtd|
        puts "  - #{tag}: #{qtd}x"
      end
    end

    puts "=========================================="
    puts "[INFO] Importação concluída!"
    puts "=========================================="
  end
end
