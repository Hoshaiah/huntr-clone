class CreateActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :activities do |t|
      t.string :title
      t.string :tag
      t.boolean :completed
      t.string :note
      t.datetime :startdate
      t.datetime :enddate
      t.references :card, null: false, foreign_key: true
      t.timestamps
    end
  end
end
