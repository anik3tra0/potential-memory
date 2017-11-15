class Account < ActiveRecord::Base
    has_many :users
    validates :business_name, :subdomain, uniqueness: true
end
