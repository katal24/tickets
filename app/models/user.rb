class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates_with BirthValidator
  validates :address, presence: true
  
  has_many :tickets

  def past_date
    if :birth > Date.today
      errors.add(:birth, "Bitrh data can't be from the feature")
    end
  end
end

