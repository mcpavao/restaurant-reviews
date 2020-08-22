class ApplicationController < ActionController::Base
  def index
    @restaurants = Restaurant.all
  end

  def show
  end

  def new
    @restaurants = Restaurant.new
  end

  def edit
  end

  def create
    @restaurants = Restaurant.new(restaurant_params)
    if @restaurant.save
      redirect_to @restaurant, notice: 'Restaurant was successfully created!'
    else
      render :new
  end
end
