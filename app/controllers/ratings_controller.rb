class RatingsController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index, :show]

  def index
    @best_rated_beers = Beer.top 5
    @best_rated_breweries = Brewery.top 5
    @best_rated_styles = Style.top 5
    @most_active_users = User.top_raters 3
    @recent_ratings = Rating.recent
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
