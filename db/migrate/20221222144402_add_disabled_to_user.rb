class AddDisabledToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :disabled, :boolean
  end
end
