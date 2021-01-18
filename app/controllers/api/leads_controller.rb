# frozen_string_literal: true

module Api
  class LeadsController < ApplicationController
    skip_before_action :authenticate_user!

    def index
      @leads = Lead.open
      render json: @leads
    end

    def show
      @lead = Lead.find(params[:id])
      render json: @lead
    end
  end
end
