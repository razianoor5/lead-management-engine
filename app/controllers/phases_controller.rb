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
  def edit; end

  # POST /phases
  def create
    authorize @phase
    unless (@user = User.find_by_email(@phase.assignee)).present? && @user.technical_manager?
      flash[:notice] = 'Wrong user email entered! Enter technical managers email'
      return render :new
    end
    @phase.users.append(@user)

    return render :new unless @phase.save

    SendMailJob.perform_now(@user, @phase)
    redirect_to lead_phases_path, notice: 'Phase was successfully created.'
  end

  # PATCH/PUT /phases/1
  def update
    respond_to do |format|
      if @phase.update(phase_params)
        format.html { redirect_to lead_phases_url, notice: 'Phase was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /phases/1
  def destroy
    @phase.destroy!
    redirect_to lead_phases_url, notice: 'Phase was successfully destroyed.'
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
    @phase.save!
    redirect_to lead_phases_url(@phase.lead_id), notice: 'Phase marked as complete successfully'
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
    authorize(@phase)
  end

  # Exceptions
  def user_not_authorized(_exception)
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to lead_phases_path(@phase.lead_id)
  end

  def record_not_save(_exception)
    flash[:alert] = 'couldn\'t save the record'
    redirect_to lead_phases_path(@phase.lead_id)
  end

  def record_not_destroyed(_exception)
    flash[:alert] = 'couldn\'t destroy the record'
    redirect_to lead_phases(@phase.lead_id)
  end

  # Only allow a list of trusted parameters through.
  def phase_params
    params.require(:phase).permit(:phase_type, :assignee, :start_date, :due_date)
  end
end
