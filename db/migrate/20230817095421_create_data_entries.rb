class CreateDataEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :data_entries do |t|
      t.string :name
      t.text :data

      t.timestamps
    end
  end
end
