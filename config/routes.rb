Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :restaurants do
    # /restaurants/...
    collection do
      # get 'top', to: 'restaurants#top', as: :top_restaurants
      # after here, go to controller and code top method
      get :top # generates '/restaurants/top'
    end
  end
end

# collections is a method in rails that allows us to
# to create new routes inside the context we are in:
# inside of resources restaurants (inside resources)

# because we are using resources

# /restaurants/:id/path
