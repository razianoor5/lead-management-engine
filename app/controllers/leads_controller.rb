# frozen_string_literal: true

class LeadsController < ApplicationController
  before_action :set_lead, only: %i[show edit update destroy close]

  # GET /leads
  def index
    @leads = Lead.all.where(is_sale: 'open')
    # @leads = current_user.leads
  end

  def show; end

  # GET /leads/new
  def new
    @lead = current_user.leads.build
    authorize @lead
  end

  # GET /leads/1/edit
  def edit; end

  # POST /leads
  def create
    # current_user.leads.build(lead_params)
    @lead = current_user.leads.new(lead_params)
    respond_to do |format|
      if @lead.save
        format.html { redirect_to @lead, notice: 'Lead was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /leads/1
  def update
    respond_to do |format|
      if @lead.update(lead_params)
        format.html { redirect_to @lead, notice: 'Lead was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def project_index
    @leads = Lead.all.where(is_sale: 'close')
    render :project
  end

  # DELETE /leads/1
  def destroy
    @lead.destroy!
    respond_to { |format| format.html { redirect_to leads_url, notice: 'Lead was successfully destroyed.' } }
  end

  def close
    if @lead.phases.pending.exists?
      redirect_to lead_url, alert: 'Lead cannot closed associated phases are pending'
    else
      @lead.is_sale = true
      @lead.save!
      redirect_to lead_url, notice: 'Lead closed successfully'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_lead
    @lead = Lead.find(params[:id])
    authorize @lead
  end

  def record_not_save(_exception)
    flash[:alert] = 'couldn\'t save the record'
    redirect_to leads_path
  end

  def record_not_destroyed(_exception)
    flash[:alert] = 'couldn\'t destroy the record'
    redirect_to leads_path
  end

  # Only allow a list of trusted parameters through.
  def lead_params
    params.require(:lead).permit!
  end
end
