class AddNameToComments < ActiveRecord::Migration[7.2]
  def change
    add_column :comments, :name, :string
  end
end
