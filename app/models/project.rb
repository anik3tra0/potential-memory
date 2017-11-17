class Project < ActiveRecord::Base
    belongs_to :user
    validates :title, :status, presence: true
end
