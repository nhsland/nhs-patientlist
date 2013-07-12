# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130129102852) do

  create_table "adms", :primary_key => "adm_id", :force => true do |t|
    t.timestamp "admstamp",                                             :null => false
    t.datetime  "admdt"
    t.datetime  "admmodifdt"
    t.date      "admdate"
    t.string    "admhospno"
    t.string    "admstatus"
    t.string    "currward"
    t.date      "wardadmdate"
    t.string    "visitcode"
    t.string    "servicecode"
    t.integer   "admpid"
    t.string    "admconsultcode"
    t.datetime  "transferdt"
    t.date      "transferdate"
    t.datetime  "dischdt"
    t.date      "dischdate"
    t.string    "dischdest"
    t.boolean   "dischflag",                         :default => false
    t.boolean   "cancelflag",                        :default => false
    t.datetime  "canceldt"
    t.boolean   "deleteflag",                        :default => false
    t.datetime  "deletedt"
    t.boolean   "clerkedflag",                       :default => false
    t.datetime  "clerkeddt"
    t.integer   "bedno"
    t.string    "admreason"
    t.string    "admixproceds"
    t.string    "admnurse"
    t.string    "ewsfreq"
    t.string    "ewsnotes"
    t.date      "preddischdate"
    t.string    "dischplan"
    t.datetime  "lastewsdt"
    t.integer   "lastews_id"
    t.integer   "lastews"
    t.integer   "prevews"
    t.integer   "ewsdiff"
    t.string    "lastewsuser"
    t.string    "mrsastatus"
    t.string    "mrsasite"
    t.date      "mrsadate"
    t.boolean   "diabeticflag",                      :default => false
    t.boolean   "invasivedeviceflag",                :default => false
    t.boolean   "immunocompflag",                    :default => false
    t.boolean   "woundsflag",                        :default => false
    t.string    "isolationstatus"
    t.datetime  "nextewsdt"
    t.text      "alertstatus"
    t.datetime  "alertstatusdt"
    t.string    "fluidstatus"
    t.text      "admnotes"
    t.datetime  "admsummdt"
    t.text      "admsummhtml"
  end

  add_index "adms", ["admconsultcode"], :name => "admconscode"
  add_index "adms", ["admdate"], :name => "admdate"
  add_index "adms", ["admhospno"], :name => "admhospno"
  add_index "adms", ["admhospno"], :name => "hospno"
  add_index "adms", ["admpid"], :name => "pid"
  add_index "adms", ["clerkedflag"], :name => "clerkedflag"
  add_index "adms", ["currward"], :name => "currward"
  add_index "adms", ["dischdate"], :name => "dischdate"
  add_index "adms", ["dischflag"], :name => "dischflag"
  add_index "adms", ["lastews"], :name => "lastews"
  add_index "adms", ["lastews_id"], :name => "lastewsid"
  add_index "adms", ["visitcode"], :name => "visitcode", :unique => true

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         :default => 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], :name => "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "colin", :id => false, :force => true do |t|
    t.string "currward"
    t.string "lastname"
    t.string "hospno"
    t.text   "pastmedhx"
    t.string "allergies"
  end

  create_table "consultants", :primary_key => "consult_id", :force => true do |t|
    t.string "consultcode"
    t.string "consultname"
    t.string "consultlastfirst"
  end

  add_index "consultants", ["consultcode"], :name => "consultcode", :unique => true
  add_index "consultants", ["consultname"], :name => "consultname"

  create_table "eventcodes", :id => false, :force => true do |t|
    t.string "eventcode"
    t.string "eventname"
    t.string "supportflag"
  end

  add_index "eventcodes", ["eventcode"], :name => "eventcode", :unique => true

  create_table "grades", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "rank"
  end

  create_table "handover_items", :force => true do |t|
    t.integer  "to_do_item_id"
    t.integer  "patient_list_from_id"
    t.integer  "patient_list_to_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "handover_items", ["patient_list_from_id"], :name => "index_handover_items_on_patient_list_from_id"
  add_index "handover_items", ["patient_list_to_id"], :name => "index_handover_items_on_patient_list_to_id"
  add_index "handover_items", ["to_do_item_id"], :name => "index_handover_items_on_to_do_item_id"

  create_table "memberships", :force => true do |t|
    t.integer "patient_list_id"
    t.integer "patient_id"
    t.string  "risk_level",      :default => "low"
  end

  add_index "memberships", ["patient_list_id", "patient_id"], :name => "index_memberships_on_patient_list_id_and_patient_id", :unique => true

  create_table "patient_lists", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "patient_lists", ["name", "user_id"], :name => "index_patient_lists_on_name_and_user_id", :unique => true

  create_table "pats", :primary_key => "pat_id", :force => true do |t|
    t.timestamp "patstamp",                                                                      :null => false
    t.datetime  "pimsmodifdt"
    t.string    "pimslastward"
    t.date      "patadddate"
    t.datetime  "patmodifdt"
    t.date      "patmodifdate"
    t.string    "hospno"
    t.string    "prefix"
    t.string    "lastname"
    t.string    "firstnames"
    t.string    "suffix"
    t.string    "sex"
    t.date      "birthdate"
    t.string    "ethnicity"
    t.string    "practicecode"
    t.string    "gpcode"
    t.string    "nhsno"
    t.string    "smoker"
    t.string    "diabetic"
    t.string    "allergies"
    t.string    "appliances"
    t.decimal   "heightm",                      :precision => 3, :scale => 2
    t.date      "heightdate"
    t.decimal   "lastweight",                   :precision => 4, :scale => 1
    t.date      "lastweightdate"
    t.decimal   "lastbmi",                      :precision => 3, :scale => 1
    t.decimal   "targetweight",                 :precision => 4, :scale => 1
    t.text      "pastmedhx"
    t.text      "medshx"
    t.text      "socialhx"
    t.string    "patmrsastatus"
    t.date      "patmrsadate"
    t.string    "deathflag"
    t.datetime  "deathdt"
    t.boolean   "mergedflag",                                                 :default => false
    t.datetime  "mergeddt"
  end

  add_index "pats", ["hospno"], :name => "pats_hospno", :unique => true
  add_index "pats", ["lastname"], :name => "lastname"
  add_index "pats", ["nhsno"], :name => "nhsno"
  add_index "pats", ["patmrsastatus"], :name => "patmrsastatus"

  create_table "risk_level_events", :force => true do |t|
    t.integer  "patient_id"
    t.string   "risk_level"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "to_do_items", :force => true do |t|
    t.integer  "patient_id"
    t.string   "description"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "state",           :default => "todo"
    t.integer  "patient_list_id"
    t.integer  "grade_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "grade_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "wards", :primary_key => "ward_id", :force => true do |t|
    t.string   "wardcode",                     :null => false
    t.string   "wardname"
    t.integer  "wardbeds"
    t.datetime "wardmodifdt"
    t.datetime "lastwardadmdt"
    t.datetime "lastwardobsdt"
    t.string   "wardbednos"
    t.string   "handoverspecs"
    t.integer  "ewsalertlevel",   :default => 0,     :null => false
    t.string   "wardpatcodes"
    t.text     "wardnotes"
    t.boolean  "termflag",                     :default => false
    t.datetime "termdt"
  end

  add_index "wards", ["wardcode"], :name => "wardcode", :unique => true

end
