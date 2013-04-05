# encoding: utf-8

class Address < ActiveRecord::Base
  belongs_to :user

  validates :user, :presence => true
  validates :name, :street_address, :city, :country, :postcode, :presence => true

end
