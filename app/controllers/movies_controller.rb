class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
		
		if params[:sort].nil? && params[:ratings].nil? &&
			(!session[:sort].nil? || !session[:ratings].nil?)
		  redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
		end
		@ratings = params[:ratings]
		if @ratings.nil?
			ratings = Movie.ratings
		else
			ratings = @ratings.keys
		end
		
		@all_ratings = Movie.ratings.inject(Hash.new) do |all_ratings, rating|
          all_ratings[rating] = @ratings.nil? ? false : @ratings.has_key?(rating) 
          all_ratings
		end
		
		order_by = params[:sort]
		if order_by == 'title'
			@title_sort = 'hilite'
			@movies = Movie.order(params[:sort]).find_all_by_rating(ratings)
		elsif order_by == 'release_date'
			@date_sort = 'hilite'
			@movies = Movie.order(params[:sort]).find_all_by_rating(ratings)
		else
			@title_header = ""
			@movies = Movie.order(params[:sort]).find_all_by_rating(ratings)
		end	
		
		session[:sort] = @sort
		session[:ratings] = @ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]                       
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
