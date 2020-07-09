class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string :company_name
      t.string :contact_name
      t.string :email
      t.string :cell
      t.string :venmo

      t.timestamps
    end
  end
end
