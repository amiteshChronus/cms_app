class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		if isProf?
  			redirect_to courses_path
  		elsif isAdmin?
        redirect_to users_path
      else
        redirect_to current_user
      end

          

  	end
  	 
  end

  def help
  end

  def about
  end

  private 
  def signed_in?
  	!current_user.nil?
  end	
end
