class CreateTractors < ActiveRecord::Migration[5.1]
  def change
    create_table :tractors do |t|
      t.references :farmer, foreign_key: true
      t.string :model

      t.timestamps
    end
  end
end
