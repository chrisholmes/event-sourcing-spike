class CreateCertificateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :certificate_groups do |t|
      t.timestamps
    end
    remove_reference :certificates, :owner, foreign_key: true
    add_reference :certificates, :owner, foreign_key: {to_table: :certificate_group}
  end
end
