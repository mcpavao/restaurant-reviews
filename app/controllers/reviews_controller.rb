class ReviewsController < ApplicationController
  before_action :find_restaurant, except: [:destroy]
  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    # we need to associate our review to a restaurant(restaurant_id)
    @review.restaurant = @restaurant
    # if not empty due to validations it will save. then:
    if @review.save
      redirect_to restaurant_path(@restaurant)
    else
      # we will stay in the create action but will display the template of the new page
      # the pnly difference is that i am not using the "new" instance of @review, i am 
      # using the instance of reciew that failed to save.
      # we can look at this instance on rails c using new_review.errors.messages
      # simple form handles that
      # render renders some html, it renders a page
      # if THE SAVE fails it will render a new page, and what is this new page? 
      # essentially my form.
      # this instance of @review has validations and will show errors
      render :new
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to restaurant_path(@review.restaurant)
  end

  private

  def find_restaurant
    # in our routes for reviews it is :restaurant_id
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def review_params
    params.require(:review).permit(:content)
  end
end

# to generate the route we need in our simple form
# we are gonna  add the restaurant instead of @review.
# so we will pass an array with BOTH [@restaurant,@review]
# to generate the route that we want
