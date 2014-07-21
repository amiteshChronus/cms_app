class QuizzesController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :show, :index, :destroy,:create, :new]
  before_filter :prof_user_only, only: [:edit, :update, :destroy, :create, :new]


  # GET /quizzes
  # GET /quizzes.json
  def index
    @quizzesHash = Hash.new
    if isAdmin?
      redirect_to root_url
    elsif isStudent?
      @courses= current_user.registered_courses
      @courses.each do |course|
        # if course.quizzes.any?
          @quizzesHash[course]=course.quizzes
        # end
      end
    elsif isProf?
      @courses= current_user.offered_courses
      @courses.each do |course|
        # if course.quizzes.any?
          @quizzesHash[course]=course.quizzes
        # end
      end
    end

  end

  # GET /quizzes/1
  # GET /quizzes/1.json
  def show

    @title="Quiz"
    @quiz = Quiz.find(params[:id])
    @havePermission=false

    if isStudent?
      @courses= current_user.registered_courses
    elsif isProf?
      @courses= current_user.offered_courses
    end
    @courses.try(:each) do |course|
        if course.quizzes.include? @quiz
          @havePermission=true
        end
    end
    if !@havePermission
      flash.now[:notice]="You don't have permission to view this quiz. If you a student then please register to the course #{@quiz.course.name}"
      redirect_to root_url
    end

  end

  # GET /quizzes/new
  # GET /quizzes/new.json
  def new
    @quiz = Quiz.new
    @course_id= params[:course_id]
    3.times do
      question= @quiz.questions.build 
      4.times {question.options.build}
    end
  end


  # GET /quizzes/1/edit
  def edit
    @quiz = Quiz.find(params[:id])
  end

  # POST /quizzes
  # POST /quizzes.json
  def create
    @quiz = Quiz.new(params[:quiz])
    

    @quiz.course_id=params[:course_id]
    respond_to do |format|
      if @quiz.save
        format.html { redirect_to @quiz, notice: 'Quiz was successfully created.' }
        format.json { render json: @quiz, status: :created, location: @quiz }
      else
        format.html { render action: "new" }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /quizzes/1
  # PUT /quizzes/1.json
  def update
    @quiz = Quiz.find(params[:id])
    @attempts= @quiz.attempts
    if @attempts.any?
      @attempts.each do |attempt|
        attempt.destroy
      end
    end
    respond_to do |format|
      if @quiz.update_attributes(params[:quiz])
        format.html { redirect_to @quiz, notice: 'Quiz was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quizzes/1
  # DELETE /quizzes/1.json
  def destroy
    @quiz = Quiz.find(params[:id])
    @quiz.destroy

    respond_to do |format|
      format.html { redirect_to quizzes_url }
      format.json { head :no_content }
    end
  end

  def attempt
    @user= current_user
    if isStudent? && !@user.attempts.where(:quiz_id => params[:id]).any?
      @attempt=@user.attempts.new()
      puts "***********************   "
      puts params
      puts "   ***********************"

      @quiz= Quiz.find(params[:id])
      @questions= @quiz.questions
      @score=0
      @answerHash =Hash.new

      @questions.each do |question|
          @correct_option= question.options.where(:correct => true).first.id
          @answerHash[question]= question.options.where(:correct => true).first.description    
          if "#{@correct_option}" == params["questions"]["#{question.id}"]["option"]
            @score=@score + 2
          end    
      end
      @user.attempts.create!(quiz_id: params[:id], marks: @score)
    else
      redirect_to root_url
    end

  end


  private 
      def signed_in_user
        unless  signed_in?
          store_location
          redirect_to signin_url, notice: "Please sign in." 
        end
      end

      def prof_user_only
        unless  isProf?
          redirect_to root_url, notice: "Only instructor can create a quiz" 
        end
      end
  
end

