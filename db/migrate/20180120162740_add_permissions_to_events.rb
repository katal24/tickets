class AddPermissionsToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :can_return, :boolean
    add_column :events, :of_age, :boolean    
  end
end
