class CreateCertificates < ActiveRecord::Migration[5.2]
  def change
    create_table :certificates do |t|
      t.string :use
      t.string :value
      t.timestamps
    end
  end
end
