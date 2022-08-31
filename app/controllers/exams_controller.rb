class ExamsController < ApplicationController
  include ExamsHelper
  before_action :find_exam, except: %i(create)
  before_action :add_answer_to_record, only: %i(update)

  def show
    @questions = @exam.questions
    @exam.set_endtime if @exam.ready?

    @list_answer = @exam.answers
  end

  def create
    @exam = current_user.exams.new exam_params
    if @exam.save
      add_questions_to_exam
      flash[:success] = t ".success_create"
    else
      flash.now[:error] = t ".fail_create"
    end
    redirect_to root_path
  end

  def update
    @exam.grade
    redirect_to root_path
  end

  private
  def find_exam
    @exam = Exam.find_by(id: params[:id])
    return if @exam.present?

    flash[:danger] = t "not_found"
    redirect_to root_path
  end

  def add_answer_to_record
    params[:exam][:question].each do |key, value|
      case Question.find_by(id: key).question_type
      when Question.types[:multiple]
        value["id"].each do |id|
          @exam.add_record Answer.find_by id: id if id != ""
        end
      when Question.types[:single]
        @exam.add_record Answer.find_by id: value["id"] if value["id"] != ""
      end
    end
  end

  def exam_params
    params.require(:exam).permit :subject_id
  end

  def user_answer_params
    params.require(:exam).permit Exam::EXAM_ATTRS
  end

  def add_questions_to_exam
    question_number = @exam.subject.question_number
    questions = @exam.subject.questions
    if questions.length <= question_number
      @exam.add questions
      return
    end

    list_question_random = random_list(question_number, questions.length)
    list_question_random.each do |random_number|
      @exam.add questions[random_number]
    end
  end
end
