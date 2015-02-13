
class MovieTest
  
	def initialize
    		@data = []
    		@mean = nil
    		@stddev = nil
    		@rms = nil
  	end
  
	
  	#add a user movie rating and prediction combo to the data array
  	def save(u,m,r,p)
    		@data << [u,m,r.to_f,p.to_f]
  	end
  
  	#returns the mean error of the data set
  	def mean
   		 if @mean.nil?
	    		total = 0
	   		@data.each do |point|
	      			total += (point[2] - point[3]).abs
	    		end
	    		@mean = total / @data.length
    		end
    		return @mean
  	end  
  
  	#return standard deviation error of data set
  	def stddev
    		total = 0
    		if @stddev.nil?
	    		@data.each do |point|
	      			diff = ((point[2] - point[3]).abs - @mean)
	      			total += (diff * diff) 
	    		end
	    		@stddev = Math.sqrt(total / @data.length)
    		end
    		return @stddev
  	end

	#return the root mean square error of data set
  	def rms
    		total = 0
    		if @rms.nil?
	    		@data.each do |point|
	      			diff = (point[2] - point[3])
	      			total += (diff * diff) 
	    		end
	    		@rms = Math.sqrt(total / @data.length)
    		end
    		return @rms
  	end

	#return the data array
  	def to_a
    		return @data
  	end

end
