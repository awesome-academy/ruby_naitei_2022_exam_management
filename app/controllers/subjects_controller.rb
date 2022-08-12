class SubjectsController < ApplicationController
  def index
    @pagy, @subject_item = pagy Subject.all, items: Settings.pagy
  end
end
