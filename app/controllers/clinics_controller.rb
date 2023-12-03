# frozen_string_literal: true

class ClinicsController < ApplicationController
  def index
    @clinics = Clinic.all
  end

  def show
    @clinic = Clinic.find(params[:id])
    @transactions = @clinic.transactions
  end
end
