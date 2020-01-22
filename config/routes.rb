Rails.application.routes.draw do
  # This is similar to manually creating the routes below
  # get '/products', to: 'products#index'
  # get '/product/:id', to: 'products#show', as: "product"
  resources :products, only: [:index, :show]

  # get '/', to: redirect { urls.products_path }, as: "root"
  root to: redirect { urls.products_path }

  def urls
    Rails.application.routes.url_helpers
  end
end
