class RenameContentToJobTitle < ActiveRecord::Migration[6.1]
  def change
    rename_column :cards, :content, :job_title
  end
end
