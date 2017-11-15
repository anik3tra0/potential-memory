class User < ActiveRecord::Base
    belongs_to :account
    validates :username, :email, uniqueness: true
end
