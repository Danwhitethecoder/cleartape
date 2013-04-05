class User < ActiveRecord::Base
  has_one :address

  validates :email, :presence => true, :uniqueness => true
  validates :phone, :presence => true
  validates :sex,   :inclusion => { :in => ["male", "female", "other"] }
  validates :age,   :presence => true,
                    :numericality => { :only_integer => true, :greater_than => 0 }
end
