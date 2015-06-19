class Ajax::ProfileController < ApplicationController

  def currency
    # authenticate_user!
    set_currency params[:currency]

    render json: { status: :success }
  end
end
