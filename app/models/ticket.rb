class Ticket < ApplicationRecord

    # validates :name, :presence => true, :length => { :minimum => 6 }
    # validates :email_address, :presence => true
    # validates :address, :presence => true    
    # validates :price, :presence => true
    validates :event_id, :presence => true, numericality: true
    validates :price, :presence => true, numericality: true
    validates :user_id, :presence => true, numericality: true    
    belongs_to :event
    belongs_to :user

end
