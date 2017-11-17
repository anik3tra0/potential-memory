class SubdomainConstraint   
  
  def self.matches?(request)     
    request.subdomain.present? && request.subdomain != 'www'   
  end 
end

Rails.application.routes.draw do
  constraints SubdomainConstraint do     
    resources :projects, except: [:new, :edit], defaults: { format: :json }
    resources :users, only: [:create, :update, :index], defaults: { format: :json }
    post '/login' => 'users#login', defaults: { format: :json } 
  end 
  resources :accounts, only: :create, defaults: { format: :json }
end
