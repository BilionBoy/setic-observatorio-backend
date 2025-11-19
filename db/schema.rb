# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_11_19_120635) do
  create_table "aplicacoes", force: :cascade do |t|
    t.string "nome"
    t.string "versao_dotnet"
    t.text "ef_core"
    t.text "problema_detalhado"
    t.text "observacao"
    t.string "tipo_authority"
    t.boolean "usa_sauron"
    t.integer "total_dlls"
    t.string "acao"
    t.string "authority"
    t.string "restsharp"
    t.string "sdk_usado"
    t.string "pacotes_criticos"
    t.string "risco"
    t.text "risco_motivo"
    t.string "tipo_auth"
    t.string "tipo"
    t.string "impacto_quebra"
    t.string "linguagem"
    t.integer "total_pacotes"
    t.text "recomendacao_detalhada"
    t.text "pacotes_nuget"
    t.boolean "usa_jwt_manual"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "prontidao_migracao"
    t.text "justificativa_prontidao"
  end

  create_table "dependencias", force: :cascade do |t|
    t.integer "aplicacao_id", null: false
    t.string "gerenciador"
    t.string "nome"
    t.string "versao"
    t.boolean "critica"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aplicacao_id"], name: "index_dependencias_on_aplicacao_id"
  end

  create_table "dependencias_internas", force: :cascade do |t|
    t.integer "sauron_modulo_id", null: false
    t.string "nome"
    t.string "versao"
    t.boolean "critica"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sauron_modulo_id"], name: "index_dependencias_internas_on_sauron_modulo_id"
  end

  create_table "sauron_modulos", force: :cascade do |t|
    t.string "nome"
    t.string "linguagem"
    t.string "versao_dotnet"
    t.string "tipo_projeto"
    t.boolean "ef_core"
    t.string "ef_core_versao"
    t.text "pacotes_nuget_lista"
    t.integer "pacotes_nuget_qtd"
    t.text "referencias_internas"
    t.boolean "usa_identityserver"
    t.boolean "usa_ldap"
    t.boolean "usa_jwt_manual"
    t.string "tipo_banco"
    t.boolean "possui_migrations"
    t.integer "qtde_migrations"
    t.text "connectionstring_nomes"
    t.string "connectionstring_principal"
    t.boolean "usa_hangfire"
    t.boolean "usa_quartz"
    t.boolean "usa_backgroundservice"
    t.boolean "usa_serilog"
    t.boolean "usa_log4net"
    t.boolean "usa_swagger"
    t.boolean "usa_automapper"
    t.boolean "usa_mediatr"
    t.boolean "usa_middleware_custom"
    t.boolean "tem_startup"
    t.boolean "usa_program_antigo"
    t.text "policies"
    t.text "controllers"
    t.text "dbcontexts"
    t.integer "services_transient"
    t.integer "services_scoped"
    t.integer "services_singleton"
    t.text "observacao"
    t.text "acao_recomendada"
    t.string "impacto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scan_results", force: :cascade do |t|
    t.string "scan_file"
    t.string "scan_name"
    t.integer "critical"
    t.integer "high"
    t.integer "medium"
    t.integer "low"
    t.float "cvss_base_score_max"
    t.float "cvssv3_base_score_max"
    t.integer "total"
    t.integer "aplicacao_id"
    t.string "aplicacao_nome"
    t.string "versao_dotnet"
    t.text "ef_core"
    t.string "linguagem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aplicacao_id"], name: "index_scan_results_on_aplicacao_id"
  end

  add_foreign_key "dependencias", "aplicacoes"
  add_foreign_key "dependencias_internas", "sauron_modulos"
  add_foreign_key "scan_results", "aplicacoes"
end
