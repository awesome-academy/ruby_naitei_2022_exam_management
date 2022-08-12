class StaticPagesController < ApplicationController
  def home
    @subject = Subject.all
  end
end
