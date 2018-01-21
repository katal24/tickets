class AddPlaceToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :place, :text
  end
end
