class ExemptionsController < ApplicationController
  before_action :authenticate_account!

  def create
    CreateExemptionWorker.perform_async(current_account.id, params[:id])

    redirect_to :back
  end
end
