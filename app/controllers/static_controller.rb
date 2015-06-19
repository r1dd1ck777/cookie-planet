class StaticController < ApplicationController
  def landing
    @recipes = Recipe.landing
    @wide_header = true
    set_menu :home
  end

  def create_feedback
    @feedback = Feedback.new( params.require(:feedback).permit(:username, :email, :text) )
    if @feedback.valid?
      OrderMailer.feedback(@feedback).deliver
      flash[:success] = "Лист відправлений."
      redirect_to contacts_path
    else
      render 'contacts'
    end
  end
end
