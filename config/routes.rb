Rails.application.routes.draw do
  # This is similar to manually creating the routes below
  # get '/products', to: 'products#index'
  # get '/product/:id', to: 'products#show', as: "product"
  resources :products, only: [:index, :show]

  get '/cart', to: 'carts#view', as: 'cart'
  post '/cart', to: 'carts#add', as: 'add_to_cart'
  delete '/cart', to: 'carts#remove', as: 'remove_from_cart'
  patch '/cart', to: 'carts#update', as: 'update_cart'

  # get '/', to: redirect { urls.products_path }, as: "root"
  root to: redirect { urls.products_path }

  def urls
    Rails.application.routes.url_helpers
  end
end
