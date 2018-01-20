class DeleteTicketIdFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :ticket_id
  end
end
