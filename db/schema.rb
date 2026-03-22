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

ActiveRecord::Schema[8.1].define(version: 2026_03_22_013524) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "menus", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "idMenu"
    t.integer "idModulo"
    t.datetime "updated_at", null: false
  end

  create_table "modulos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "strNombreModulo"
    t.datetime "updated_at", null: false
  end

  create_table "perfils", force: :cascade do |t|
    t.boolean "bitAdministrador"
    t.datetime "created_at", null: false
    t.string "strNombrePerfil"
    t.datetime "updated_at", null: false
  end

  create_table "permisos_perfils", force: :cascade do |t|
    t.boolean "bitAgregar"
    t.boolean "bitConsulta"
    t.boolean "bitDetalle"
    t.boolean "bitEditar"
    t.boolean "bitEliminar"
    t.datetime "created_at", null: false
    t.integer "idModulo"
    t.integer "idPerfil"
    t.datetime "updated_at", null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "idEstadoUsuario"
    t.integer "idPerfil"
    t.string "password_digest"
    t.string "strCorreo"
    t.string "strNombreUsuario"
    t.string "strNumeroCelular"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
