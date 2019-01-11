class CreateCertificateGroupEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :certificate_group_events do |t|
      t.string :type, null: false
      t.json :data
      t.references :certificate_group
      t.timestamps
    end
  end
end
