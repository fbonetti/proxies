class CreateProxies < ActiveRecord::Migration
  def change
    create_table :proxies do |t|
      t.cidr :host
      t.integer :port
      t.boolean :http
      t.boolean :https
      t.string :country
      t.datetime :last_live_at

      t.timestamps null: false
    end

    add_index :proxies, [:host, :port], unique: true
  end
end
