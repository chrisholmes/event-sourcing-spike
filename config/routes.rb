Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/certificates' => 'certificates#create_group', as: :create_certificate_groups
  get '/certificates' => 'certificates#index', as: :show_certificates
  get '/certificates/:id' => 'certificates#show', as: :show_certificate_group
  post '/certificates/:id/certificate' => 'certificates#create_certificate', as: :create_certificate
end
