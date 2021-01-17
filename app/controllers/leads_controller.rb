# frozen_string_literal: true

class LeadsController < ApplicationController
  before_action :set_lead, only: %i[show edit update destroy close]

  # GET /leads
  def index
    @leads = Lead.open
    respond_to do |format|
      format.html
      format.json { render json: @leads }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: { lead: @lead, comments: @lead.comments } }
    end
  end

  # GET /leads/new
  def new
    @lead = current_user.leads.build
    authorize @lead
  end

  # GET /leads/1/edit
  def edit; end

  # POST /leads
  def create
    @lead = current_user.leads.new(lead_params)
    respond_to do |format|
      if @lead.save
        format.html { redirect_to @lead, notice: I18n.t('leads.created') }
      else
        format.html { render :new, notice: I18n.t('leads.not_created') }
      end
    end
  end

  # PATCH/PUT /leads/1
  def update
    respond_to do |format|
      if @lead.update(lead_params)
        format.html { redirect_to @lead, notice: I18n.t('leads.created') }
      else
        format.html { render :edit, notice: I18n.t('could_not_update_record') }
      end
    end
  end

  def project_index
    @leads = Lead.close
    render :project
  end

  # DELETE /leads/1
  def destroy
    flash[:notice] = if @lead.destroy
                       I18n.t('leads.destroyed')
                     else
                       I18n.t('leads.not_destroyed')
                     end

    redirect_to leads_url
  end

  def close
    if @lead.phases.pending.exists?
      redirect_to lead_url, alert: I18n.t('leads.close_failure')
    else
      notice = if @lead.update(is_sale: true)
                 I18n.t('leads.close_success')
               else
                 I18n.t('leads.close_failure')
               end

      redirect_to lead_url, notice: notice
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_lead
    @lead = Lead.find(params[:id])
    authorize @lead
  end

  # Only allow a list of trusted parameters through.
  def lead_params
    params.require(:lead).permit(:project_name, :client_name, :client_address,
                                 :client_email, :client_contact, :platform_used,
                                 :user_id)
  end
end
