class RegistrationsController < ApplicationController
	before_filter :signed_in_user

	def create
		@course =Course.find(params[:registration][:course_id])
		current_user.register!(@course)
		redirect_to current_user
	end

	def destroy
		#@course = Registration.find_by_course_id(params[:registration][:course_id]).course
		@course = Registration.find(params[:id]).course
		current_user.unregister!(@course)
		redirect_to current_user
	end

	private
		def signed_in_user
	      unless  signed_in?
	        store_location
	        redirect_to signin_url, notice: "Please sign in." 
	      end
    	end
end