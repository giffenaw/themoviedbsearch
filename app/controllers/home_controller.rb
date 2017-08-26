class HomeController < ApplicationController
  def index
  	response = HTTParty.get("https://api.themoviedb.org/3/search/movie?api_key=0ff635a62d30604c0001931e63a24938&query=The+Parent+Trap")
  	@total_results = 0
    @total_pages = 0
  	@results_message = ""
  	@index = Array.new
  	@titles = Array.new
  	@images = Array.new

  	if params[:movie] != ""
  		if params[:movie] != nil
  			response = HTTParty.get("https://api.themoviedb.org/3/search/movie?api_key=0ff635a62d30604c0001931e63a24938&query=#{params[:movie]}")
  			@total_results = response['total_results']
        @total_pages = response['total_pages']
        @current_page = 1

        #loop through all pages with 20 results and push titles/posters to arrays
        while (@current_page < @total_pages) do
          i = 0
          while (i < 20) do
            @index.push(i + 20*(@current_page-1))
            @titles.push(response['results'][i]['original_title'])
            @images.push("https://image.tmdb.org/t/p/w185#{response['results'][i]['poster_path']}")
            i += 1
          end
          @current_page += 1
          response = HTTParty.get("https://api.themoviedb.org/3/search/movie?api_key=0ff635a62d30604c0001931e63a24938&query=#{params[:movie]}&page=#{@current_page}")
        end

  			i = 0
		  	while (i < (@total_results % 20)) do
		  		@index.push(i + 20*(@current_page-1))
		  		@titles.push(response['results'][i]['original_title'])
		  		@images.push("https://image.tmdb.org/t/p/w185#{response['results'][i]['poster_path']}")
		  		i+=1
		  	end

  		  if @total_results == 0
  		  	@results_message = "No movies matched your search. Please try again."
  		  elsif @total_results == 1
  		  	@results_message = "#{@total_results} movie found."
  		  else
    			@results_message = "#{@total_results} movies found."
    		end #end @results_message generation

      end #end params[:movie] != nil

  	end #end params[:movie] != ""
  end #end index definition
end #end class definition
