class Event < ApplicationRecord
    validates :artist, presence: true
    validates :price_low, presence: true, numericality: true
    validates :price_high, presence: true, numericality: true
    validates :event_date, presence: true
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
