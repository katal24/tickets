class DeleteDetailsFromTickets < ActiveRecord::Migration[5.1]
  def change
    remove_column :tickets, :name
    remove_column :tickets, :address
    remove_column :tickets, :email_address
    remove_column :tickets, :phone
  end
end
