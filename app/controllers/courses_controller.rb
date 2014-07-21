class CoursesController < ApplicationController
  before_filter :signed_in_user
  # GET /courses
  # GET /courses.json
  def index
    @current_user=current_user
    if isAdmin?
      @courses = Course.paginate(page: params[:page])
    elsif isProf?
      @title = "All Courses Offered"
      @courses= @current_user.offered_courses.paginate(page: params[:page])
    elsif isStudent?
      @title = "All Courses Offered"
      @courses= Course.paginate(page: params[:page])

      # @courses= @current_user.registered_courses.paginate(page: params[:page])
    else
      redirect_to root_url
    end
      
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courses }
    end
  end

  def my_course
    if isStudent?
      @title = "Courses Registered"
      @courses= current_user.registered_courses.paginate(page: params[:page])      
    elsif isProf?
      @title = "All Courses Offered"
      @courses= current_user.offered_courses.paginate(page: params[:page])
    else
      redirect_to root_url
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @course = Course.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.json
  def new
    redirect_to '/new_course'
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])
    if !current_user.offered_courses.include? @course
      redirect_to root_url
    end
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(params[:course])

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render json: @course, status: :created, location: @course }
      else
        format.html { render action: "new" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.json
  def update
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :no_content }
    end
  end


  def students
    @title= "Registered Students"
    @course=Course.find(params[:id])
    @students= @course.students
    render 'show_students'
  end


  def quizzes
    @title= "Conducted Quizzes"
    @course=Course.find(params[:id])
    @quizzes= @course.quizzes
    if !@quizzes.any?
      flash.now[:notice] = "This course have no quiz yet!"
    end
  end

  

end
