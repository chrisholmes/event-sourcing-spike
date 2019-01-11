class AddCertificateOwner < ActiveRecord::Migration[5.2]
  def change
    add_reference :certificates, :owner, foreign_key: {to_table: :relying_party}
  end
end
