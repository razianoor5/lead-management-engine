# frozen_string_literal: true

class LeadsController < ApplicationController
  before_action :set_lead, only: %i[show edit update destroy]

  # GET /leads
  def index
    @leads = current_user.leads
    # @leads = current_user.leads
  end

  # GET /leads/1
  # GET /leads/1.json
  def show; end

  # GET /leads/new
  def new
    @lead = current_user.leads.build
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
  # PATCH/PUT /leads/1.json
  def update
    respond_to do |format|
      if @lead.update(lead_params)
        format.html { redirect_to @lead, notice: 'Lead was successfully updated.' }
      else
        format.html { render :edit }

      end
    end
  end

  # DELETE /leads/1
  def destroy
    @lead.destroy
    respond_to do |format|
      format.html { redirect_to leads_url, notice: 'Lead was successfully destroyed.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_lead
    @lead = Lead.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def lead_params
    params.require(:lead).permit!
  end
end
