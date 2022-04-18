class RemoveDescriptionFromKanbans < ActiveRecord::Migration[6.1]
  def change
    remove_column :kanbans, :description, :string
  end
end
