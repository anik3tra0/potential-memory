class User < ActiveRecord::Base
    validates :username, :email, uniqueness: true
    has_many :projects

    after_create :generate_token

    private

    def generate_token
        self.token = SecureRandom.hex(32)
        self.save
    end

end
