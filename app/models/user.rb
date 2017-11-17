class User < ActiveRecord::Base
    belongs_to :account
    validates :username, :email, uniqueness: true

    after_create :generate_token

    private

    def generate_token
        self.token = SecureRandom.hex(32)
        self.save
    end

end
