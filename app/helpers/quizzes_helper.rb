module QuizzesHelper

	def quiz_average(quiz) 
      @attempts=quiz.attempts.select("marks")
      if @attempts.any?
        @sum=0
        @attempts.each do |attempt|
          @sum=@sum+attempt.marks
        end
        @sum/@attempts.count
      else 
        "Not attempted"
      end      
    end

    
end
