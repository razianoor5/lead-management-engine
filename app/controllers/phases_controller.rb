# frozen_string_literal: true

class PhasesController < ApplicationController
  before_action :set_phase, only: %i[show edit update destroy engineer complete]

  def index
    if current_user.technical_manager?
      @phases = current_user.phases
    else
      @lead = Lead.find(params[:lead_id])
      @phases = @lead.phases
    end
  end

  # GET /phases/1
  def show
    @users = User.includes(:phases).engineer.filter { |engineer| engineer.phases.count.zero? }
  end

  # GET /phases/new
  def new
    @phase = Phase.new
  end

  # GET /phases/1/edit
  def edit; end

  # POST /phases
  def create

    @lead = Lead.find(params[:lead_id])
    @phase = @lead.phases.new(phase_params)
    user = User.find_by(email: @phase.assignee)
    @phase.users.append(user)
    respond_to do |format|
      if @phase.save
        UserMailer.phase_assignment_email(user, @phase).deliver_now
        format.html { redirect_to lead_phases_path, notice: 'Phase was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /phases/1
  def update
    respond_to do |format|
      if current_user.technical_manager? && @phase.update(phase_params)
        format.html { redirect_to phases_url, notice: 'Phase was successfully updated.' }
      elsif current_user.business_developer? && @phase.update(phase_params)
        format.html { redirect_to lead_phases_url, notice: 'Phase was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /phases/1
  def destroy
    @phase.destroy
    if current_user.technical_manager?
      redirect_to phases_url, notice: 'Phase was successfully destroyed.'
    else
      redirect_to lead_phases_url, notice: 'Phase was successfully destroyed.'
    end
  end

  #Adding engineers

  def engineer
    @engineer = User.find(params[:engineer][:user_id])
    @phase.users.append(@engineer)
    redirect_to phase_url, notice: 'Engineer was successfully added.'
  end

  def complete
    @phase.is_complete = true
    @phase.save!
    redirect_to phase_url, notice: 'Phase marked as complete successfully'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_phase
    @phase = Phase.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def phase_params
    params.require(:phase).permit(:phase_type, :assignee, :start_date, :due_date)
  end
end
