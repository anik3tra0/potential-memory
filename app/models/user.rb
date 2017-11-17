class User < ActiveRecord::Base
    validates :username, :email, uniqueness: true
    has_many :projects
end
