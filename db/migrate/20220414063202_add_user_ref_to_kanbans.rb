class AddUserRefToKanbans < ActiveRecord::Migration[6.1]
  def change
    add_reference :kanbans, :user, null: false, foreign_key: true
  end
end
