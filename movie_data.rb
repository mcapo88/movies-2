#Mark Capobiano
#cs105b
#Movies 1

class MovieData
	attr_reader :movies, :movie_users, :user_movies, :just_movies, :just_users #getter methods
	def initialize(filename)
		@movie_users = {}
		@user_movies = {}
		@just_movies = {}
		@just_users = {}
		@movies = load_data(filename)
	end
	
	#breaks up the file into various hashes to use throughout the program and elimates duplicate key values
	def load_data(u)
		
		# user \t movie \t rating \t timestamp
		File.open(u,"r").each_line do |line|
			categories = line.split("\t")
			if !@movie_users.key?(categories[1])
			  @movie_users[categories[1]] = {}
			end
			if !@user_movies.key?(categories[0])
			  @user_movies[categories[0]] = {}
			end
			if !@just_movies.include?(categories[1])
				@just_movies[categories[1]] = {}
			end
			if !@just_users.include?(categories[0])
				@just_users[categories[0]] = {}
			end
			@movie_users[categories[1]][categories[0]] = categories[2] #movie ==> {user ==> rating}
			@user_movies[categories[0]][categories[1]] = categories[2] #user ==> {movie ==> rating}
			@just_movies[categories[1]] = popularity(categories[1])
			
		end
	
	
	end

	def movie_rating(user,movie) #return a rating of a given user and movie combination 
                        return @user_movies[user.to_s][movie.to_s]
        end
        
        def already_rated(user,movie) #if movie has already been rated by user return rating or return 0 is not already rated
                if movie_rating(user,movie) != nil
                        return movie_rating(user,movie)
                else 
                        return 0
                end
        end

	
	def movies(user) # return a list of movies a user has rated
		return @user_movies[user.to_s].keys
	end
	
	def users(movie) #return a list of users that rated a given movie
		return @movie_users[movie.to_s].keys
	end
	
	#method returns a popularity rating for a given movie, Popularity is decided by total number of user ratings a movie received.
	def popularity (movie)
	
		users_rated = users(movie)
		
		num_users = users_rated.length
		
		return num_users
		
	end

        def total_user_ratings(user) #gives a cumulative ratings score of all movies a user rated
                movies = movies(user)
                ratings = 0

                movies.each do |movie|
                         ratings = ratings += movie_rating(user,movie).to_f
                end
                   
                return (ratings / movies.length).to_f

        end



        def total_movie_ratings(movie)# gives a cumulative ratings of every users ratings of a movie
                users = users(movie)
                ratings = 0 
                
                users.each do |user|
                        ratings = ratings += movie_rating(user,movie).to_f
                end

                return (ratings / users.length).to_f

        end
                        

	
	#creates a list of movie id's sorted in decreasing order
	def popularity_list
	
		sorted_list = Hash[@just_movies.sort_by {|key, value| value}.reverse]
		reverse_sort = Hash[sorted_list.sort_by {|key, value| value}]
		
		most_popular = sorted_list.first(10)
		least_popular = reverse_sort.first(10)
		
		puts "The ten most popular movies based on number of user ratings are: "
		
		most_popular.each {|key, value| puts "Movie number #{key} with #{value} total rating(s)"}
		
		puts "\nThe ten least popular movies based on number of user ratings are: "
		
		least_popular.each {|key, value| puts "Movie number #{key} with #{value} total rating(s)"}
		
	end
	
	#returns a similarity score based on how many degrees away 2 user ratings are apart from each other
	def rating_system(movie, u1, u2)
	
		u1_rating = movie_rating(u1,movie)
		u2_rating = movie_rating(u2,movie)
		
		if (u1_rating.to_i - u2_rating.to_i).abs == 0
			return 15
		elsif (u1_rating.to_i - u2_rating.to_i).abs == 1
			return 8
		elsif (u1_rating.to_i - u2_rating.to_i).abs == 2
			return 4
		elsif (u1_rating.to_i - u2_rating.to_i).abs == 3
			return 2
		else
			return 0
		end
	end
	
	#method takes 2 user ids and generates a similarity score based on 
	def similarity (user1,user2)
		score = 0
		
		user1_movies = movies(user1)
		user2_movies = movies(user2)
		
		#outer if else statement chooses the user that rated less movies as the driver user to save time.
		if (user1_movies.length >= user2_movies.length) 
			user2_movies.each do |movie|
				if user1_movies.include?(movie)
					score += rating_system(movie, user1, user2)
				end
			end
		else
			user1_movies.each do |movie|
				if user2_movies.include?(movie)
					score += rating_system(movie, user1, user2)
				end
			end
		end
		
		return score
	end
	
	#returns a similarity score based on how many degrees away 2 user ratings are apart from each other
	def most_similar (u)
	
		@just_users.delete(u)
		
		@just_users.each {|user, sim| @just_users[user] = similarity(u,user[0])}
		
		
		sorted_list = Hash[@just_users.sort_by {|key, value| value}.reverse]
		reverse_sort = Hash[sorted_list.sort_by {|key, value| value}]
			
		most_similar = sorted_list.first(10)
		least_similar = reverse_sort.first(10)
		
		puts "The ten most similar users to User # #{u} based on number of common user ratings are: "
		
		
		most_similar.each {|key, value| puts "User number #{key} with a  #{value} similarity rating"}
		
		puts "\nThe ten least similar users to User # #{u} based on number of common user ratings are: "
		
		least_similar.each {|key, value| puts "User number #{key} with a #{value} similarity rating"}
		

	end

	def predict (user, movie)

                if already_rated(user,movie) != 0
                        puts "User #{user} has already rated movie #{movie}"
                else
                        puts "We predict that user #{user} would give movie #{movie} a rating of #{final_prediction(user,movie)}"   
                
	        end
        end

        def final_prediction(user,movie)

             ((total_user_ratings(user) +  total_movie_ratings(movie))/2).round(1)
        
        end  

                

	
end


md = MovieData.new('ml-100k/u.data')

#md.popularity_list

puts "user 1 rated movie 3 as #{md.already_rated(1,600)}"

puts "user 1's total user rating is #{md.total_user_ratings(1)}"

puts "movie 600's total user rating is #{md.total_movie_ratings(600)}"

md.predict(1,1)
md.predict(1,600)

#puts "Enter your user number "
#user = $stdin.gets.chomp.to_s

#md.most_similar(user)


 



