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

ActiveRecord::Schema[8.1].define(version: 2025_12_07_214223) do
  create_table "calificaciones", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descripcion"
    t.integer "estudiante_id", null: false
    t.string "nombre_evaluacion"
    t.decimal "nota", precision: 5, scale: 2, null: false
    t.integer "taller_id", null: false
    t.string "tema"
    t.datetime "updated_at", null: false
    t.index ["estudiante_id"], name: "index_calificaciones_on_estudiante_id"
    t.index ["taller_id"], name: "index_calificaciones_on_taller_id"
  end

  create_table "estudiantes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "curso"
    t.integer "max_talleres_por_periodo", default: 3
    t.string "nombre"
    t.integer "taller_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["taller_id"], name: "index_estudiantes_on_taller_id"
    t.index ["user_id"], name: "index_estudiantes_on_user_id"
  end

  create_table "inscripciones", force: :cascade do |t|
    t.string "estado", default: "pendiente"
    t.integer "estudiante_id", null: false
    t.integer "taller_id", null: false
    t.index ["estado"], name: "index_inscripciones_on_estado"
    t.index ["estudiante_id", "taller_id"], name: "index_inscripciones_on_estudiante_id_and_taller_id", unique: true
    t.index ["estudiante_id"], name: "index_inscripciones_on_estudiante_id"
    t.index ["taller_id"], name: "index_inscripciones_on_taller_id"
  end

  create_table "talleres", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "cupos"
    t.text "descripcion"
    t.date "fecha"
    t.string "nombre"
    t.integer "numero_evaluaciones", default: 5
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "calificaciones", "estudiantes"
  add_foreign_key "calificaciones", "talleres"
  add_foreign_key "estudiantes", "talleres"
  add_foreign_key "estudiantes", "users"
  add_foreign_key "inscripciones", "estudiantes"
  add_foreign_key "inscripciones", "talleres"
end
