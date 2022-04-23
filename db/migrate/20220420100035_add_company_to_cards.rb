class AddCompanyToCards < ActiveRecord::Migration[6.1]
  def change
    add_column :cards, :company, :string
  end
end
