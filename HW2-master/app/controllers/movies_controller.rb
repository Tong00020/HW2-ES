# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController

  def index
    @all_ratings = Movie.all_ratings
    redirect = false
    logger.debug(session.inspect)
    if params[:sort_by]
	@sort_by = params[:sort_by]
	session[:sort_by] = params[:sort_by]
    elsif session[:sort_by]
	@sort_by = session[:sort_by]
	rediredt = true
    else
	@sort_by = nil
    end

   if params[:commit] == "Refresh" and params[:rating].nil?
	@rating = nil
	session[:ratings] = nil
   elsif params[:ratings]
	@ratings = params[:ratings]
	session[:ratings] = params[:ratings]
   elsif session[:ratings]
	@ratings = session[:ratings]
	redirect = true
   else
	@ratings=nil
   end

   if redirect 
	flash.keep
	redirect_to moviespath :sort_by => @sort_by, :ratings => ratings 
   end

    @sort_by = params[:sort_by]
    @ratings = params[:ratings]
    #@movies = Movie.find(:all, :order => (params[:sort_by]))
	if @ratings and @sort_by
	 @movies = Movie.where(:ratings => @ratings.keys).find(:all, :order => (sort_by))
	elsif @ratings
	 @movies = Movie.where(:ratings => @ratings.keys)
	elsif @sort_by
	 @movies = Movie.find(:all, :order => (@sort_by))
	else
	 @movie = Movie.all
	end
	
	if !@ratings
	 @ratings = Hash.new
	end
	#@movies = Movie.all
	# if params[:ratings]
	#    @movies = Movie.where(:ratings => params[:ratings].keys).find(:all, :order => (params[:sort_by]))
	# end
	#@sort_column = params[:sort_by]
	#@all_ratings = Movie.all_ratings
	#@set_ratings = params[:ratings]
	#if !set_ratings
	# @set_ratings = Hash.new
	#end
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def new
    @movie = Movie.new
  end

  def create
    #@movie = Movie.create!(params[:movie]) #did not work on rails 5.
    @movie = Movie.create(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created!"
    redirect_to movies_path
  end

  def movie_params
    params.require(:movie).permit(:title,:rating,:description,:release_date)
  end

  def edit
    id = params[:id]
    @movie = Movie.find(id)
    #@movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    #@movie.update_attributes!(params[:movie])#did not work on rails 5.
    @movie.update(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated!"
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "#{@movie.title} was deleted!"
    redirect_to movies_path
  end
end