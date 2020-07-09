class CreateGigs < ActiveRecord::Migration[6.0]
  def change
    create_table :gigs do |t|
      t.string :title
      t.string :service_type
      t.references :service, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.text :details
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
