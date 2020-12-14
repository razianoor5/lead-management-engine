# frozen_string_literal: true

class PhasesController < ApplicationController
  before_action :set_phase, only: %i[show edit update destroy]

  def index
    @lead = Lead.find(params[:lead_id])
    @phases = @lead.phases
  end

  # GET /phases/1
  def show; end

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
      if @phase.update(phase_params)
        format.html { redirect_to lead_phases_url, notice: 'Phase was successfully updated.' }

      else
        format.html { render :edit }

      end
    end
  end

  # DELETE /phases/1

  def destroy
    @phase.destroy
    respond_to do |format|
      format.html { redirect_to lead_phases_url, notice: 'Phase was successfully destroyed.' }
    end
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
