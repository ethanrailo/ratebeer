class RemoveBeerIdFromStyles < ActiveRecord::Migration[7.0]
  def change
    remove_column(:styles, :beer_id)
  end
end
