class MoteesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :complete_user!
  
  before_filter :set_motee, only: [:show, :edit, :update]

  def index
    @motees = current_user.motees

    redirect_to new_motee_path if @motees.empty?
  end

  def new
    @motee = Motee.new
  end

  def create
    @motee = Motee.new secure_params.merge(user_id: current_user.id)

    if @motee.save
      redirect_to action: 'index'
    else
      render :new
    end
  end

  private

  def set_motee
    @motee = current_user.motees.find params[:id]
  end

  def secure_params
    params.require(:motee).permit(:text)
  end

end
