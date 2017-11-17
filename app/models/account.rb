class Account < ActiveRecord::Base
    validates :business_name, :subdomain, uniqueness: true

    after_create :create_tenant

    private

    def create_tenant 
      Apartment::Tenant.create(subdomain) 
    end 
end
