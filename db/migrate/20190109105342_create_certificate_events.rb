class CreateCertificateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :certificate_events do |t|
      t.string :type, null: false
      t.json :data
      t.references :certificate
      t.timestamps
    end
  end
end
