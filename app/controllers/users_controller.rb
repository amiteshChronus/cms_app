class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index,:create_prof,:new_prof,:show]
  before_filter :correct_user,  only: [:edit, :update]
  

  # GET /users
  # GET /users.json
  def index
    if isAdmin?
      @title= "Listing All Professors"
      @users = User.where('role' => 2).paginate(page: params[:page])
      if(!@users.any?)
        flash[:notice]= "No professor on CMS. To create a new professor click on Create New Professor"
      end
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @users }
      end
    else
      flash[:notice]= "You don't have permission to browse all users"
      redirect_to courses_path
    end
  end

  # GET /users/1
  # GET /users/1.json

  

  def show
    @user = User.find(params[:id])

    # @user = User.find(params[:id])
    # if isAdmin?
    #   @users =User.where('role' => 2)
    # elsif isProf?
    #   @courses= @user.offered_courses
    # elsif isStudent?
    #   @courses= Course.all
    # end  
  end

  # GET /users/new
  # GET /users/new.json
  def new

    if signed_in? && !isAdmin?
      sign_out
      redirect_to signup_url
    elsif signed_in? && isAdmin?
      redirect_to "/new_prof"
    end
    @title= "Sign Up"
    @user = User.new

    
  end


  def new_course
    if !isProf?
      flash[:notice]= "Only professors are allowed to create course"
      redirect_to courses_path
    end

    @course= Course.new
    
  end


  def create_course
    @user = current_user
    @course = Course.new(params[:course])
    respond_to do |format|
      if @course.save
        @offering=@user.offerings.build(:course_id => @course.id ).save
        format.html { redirect_to current_user, notice: 'New Course created' }
        format.json { render json: current_user, status: :created, location: current_user }
      else
        format.html { render action: "new_course" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end


  def new_prof
    if !isAdmin?
      # flash[:notice]= "You don't have permission to browse all users"
      flash[:notice]= "Only admin can create new professor account."
      redirect_to courses_path
    end
    @title ="Create new professor"
    @prof = User.new
    
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create

    @user = User.new(params[:user])
    @user.role=3
    respond_to do |format|
      if @user.save
        sign_in @user
        format.html { redirect_to @user, notice: 'Welcome to the CMS!' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  def create_prof
    if !isAdmin?
      flash.now[:notice]= "Only admin can create new professor account."
      redirect_to courses_path
    end
    @user = current_user
    @prof = User.new(params[:user])
    password=random_string(6)
    @prof.password=password
    @prof.password_confirmation=password
    @prof.role=2
    Emailer.send_mail(@prof).deliver
    respond_to do |format|
      if @prof.save
        format.html { redirect_to users_path, notice: 'New prof created' }
        format.json { render json: current_user, status: :created, location: current_user }
      else
        format.html { render action: "new_prof" }
        format.json { render json: @prof.errors, status: :unprocessable_entity }
      end
    end
  end 

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        sign_in @user
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Professor account destroyed."
    redirect_to users_path
  end

  private 

    

    def correct_user
      @user = User.find(params[:id])
      redirect_to(user_path(current_user)) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless isAdmin?
    end

    def prof_user
      redirect_to(root_url) unless isProf?
    end

    def student_user
      redirect_to(root_url) unless isStudent?
    end

    def random_string(length=6)
      chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ0123456789'
      password = ''
      length.times { password << chars[rand(chars.size)] }
      password
    end

end
