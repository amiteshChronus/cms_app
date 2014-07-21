class RegistrationsController < ApplicationController
	before_filter :signed_in_user

	def create
		@course =Course.find(params[:registration][:course_id])
		current_user.register!(@course)
		redirect_to courses_path
	end

	def destroy
		#@course = Registration.find_by_course_id(params[:registration][:course_id]).course
		@course = Registration.find(params[:id]).course
		@attempts=current_user.attempts
		if(@attempts.any?)
			@attempts.each do |attempt|
				attempt.destroy
			end
		end	
		current_user.unregister!(@course)
		redirect_to courses_path
	end

	private
		def signed_in_user
	      unless  signed_in?
	        store_location
	        redirect_to signin_url, notice: "Please sign in." 
	      end
    	end
end