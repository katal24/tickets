class ChangeTypeInCashColumn < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :cash, :decimal
  end
end
