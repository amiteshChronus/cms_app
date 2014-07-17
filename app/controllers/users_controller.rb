class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index]
  before_filter :correct_user,  only: [:edit, :update]
  before_filter :admin_user, only: [:create_prof]

  # GET /users
  # GET /users.json
  def index
    if isAdmin?
      @users = User.where('role' => 2)
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @users }
      end
    end

  end

  # GET /users/1
  # GET /users/1.json

  

  def show
    @user = User.find(params[:id])
    if isAdmin?
      @users =User.where('role' => 2)
    elsif isProf?
      @courses= @user.offered_courses
    elsif isStudent?
      @courses= Course.all
    end  
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end


  def new_course
    @course= Course.new
    respond_to do |format|
      format.html # new_prof.html.erb
    end
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
    @prof = User.new
    respond_to do |format|
      format.html # new_prof.html.erb
    end
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
    @user = current_user
    @prof = User.new(params[:user])
    password="bhinder" #rand(6**length).to_s(6)""
    @prof.password=password
    @prof.password_confirmation=password
    @prof.role=2
    respond_to do |format|
      if @prof.save
        format.html { redirect_to current_user, notice: 'New prof created' }
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
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  private 

    def signed_in_user
      unless  signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in." 
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
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

    

end
