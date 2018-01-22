class Event < ApplicationRecord
    validates :artist, presence: true
    validates :event_date, presence: true
    validates_with EventDateValidator
    validates :place, presence: true
    # validates :place, format: { with: /(\d+:\d+(\.\d{0,2})?;)+/, message: "only format number:price;"}
    
    has_many :tickets
    serialize :place, Hash
    # def self.search(search)
    #     if search
    #       find(:all, :conditions => ['artist LIKE ?', "%#{search}%"])
    #     else
    #       self.all
    #     end
    #   end
end
