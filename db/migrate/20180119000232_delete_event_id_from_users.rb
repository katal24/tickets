class DeleteEventIdFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :event_id
  end
end
