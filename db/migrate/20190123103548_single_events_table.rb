class SingleEventsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :type, null: false
      t.json :data
      t.references :aggregate, polymorphic: true
      t.timestamps
    end
    drop_table :certificate_events
    drop_table :certificate_group_events
  end
end
