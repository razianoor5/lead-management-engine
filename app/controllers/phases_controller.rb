# frozen_string_literal: true

class PhasesController < ApplicationController
  before_action :set_phase, only: %i[show edit update destroy engineer complete]
  before_action :load_lead, only: :create
  before_action :load_and_authorize_phase, only: :create

  def index
    @lead = Lead.find(params[:lead_id])
    @phases = @lead.phases
  end

  # GET /phases/1
  def show
    @users = User.engineer
  end

  # GET /phases/new
  def new
    @phase = Lead.find(params[:lead_id]).phases.build
    authorize @phase
  end

  # GET /phases/1/edit
  def edit
    authorize @phase
  end

  # POST /phases
  def create
    authorize @phase
    unless (@user = User.find_by_email(@phase.assignee)).present? && @user.technical_manager?
      flash[:notice] = 'Wrong user email entered! Enter technical managers email'
      return render :new
    end
    @phase.users.append(@user)

    return render :new, notice: 'phase can not be save' unless @phase.save

    SendMailJob.perform_now(@user, @phase)
    redirect_to lead_phases_path, notice: 'Phase was successfully created.'
  end

  # PATCH/PUT /phases/1
  def update
    authorize @phase
    respond_to do |format|
      if @phase.update(phase_params)
        format.html { redirect_to lead_phases_url, notice: 'Phase was successfully updated.' }
      else

        # flash[:notice] = 'Phase was not updated.'
        format.html { render :edit, notice: 'Phase was not updated.' }
      end
    end
  end

  # DELETE /phases/1
  def destroy
    authorize @phase
    if @phase.destroy
      flash[:notice] = 'Phase was successfully destroyed.'
    else
      flash[:alert] = 'Phase was not destroyed.'
    end
    redirect_to lead_phases_url
  end

  # Adding engineers

  def engineer
    @engineer = User.find(params[:engineer][:user_id])
    if @phase.users.exists?(@engineer.id)
      flash[:alert] = 'already assigned in the phase'
    else
      @phase.users.append(@engineer)
      flash[:notice] = 'Engineer was successfully added.'
    end
    redirect_to lead_phase_url(@phase.lead_id)
  end

  def complete
    @phase.is_complete = true
    if @phase.save
      flash[:alert] = 'Phase marked as complete successfully'
    else
      flash[:alert] = 'Phase can not be mark as complete '
    end
    redirect_to lead_phases_url(@phase.lead_id)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_phase
    @phase = Phase.find(params[:id])
  end

  def load_lead
    @lead ||= Lead.find_by(id: params[:lead_id])
  end

  def load_and_authorize_phase
    @phase ||= @lead.phases.new(phase_params)
    authorize @phase
  end

  # Exceptions
  def user_not_authorized(_exception)
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to lead_phases_path(@phase.lead_id)
  end

  # Only allow a list of trusted parameters through.
  def phase_params
    params.require(:phase).permit(:phase_type, :assignee, :start_date, :due_date, :lead_id)
  end
end
