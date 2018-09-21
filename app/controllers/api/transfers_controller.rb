# frozen_string_literal: true

module API
  class TransfersController < ApplicationController
    def create
      response = execute_transfer
      status = response[:status] == :ok ? :ok : :bad_request

      render json: response, root: false, status: status
    end

    private

    def amount
      @amount ||= BigDecimal(permitted_params[:amount] || 0)
    end

    def destination_account_id
      @destination_account_id ||= permitted_params[:destination_account_id].to_i
    end

    def execute_transfer
      TransferService.transfer_money(source_account_id,
                                     destination_account_id,
                                     amount)
    end

    def source_account_id
      @source_account_id ||= permitted_params[:source_account_id].to_i
    end

    def permitted_params
      params.permit(:amount, :destination_account_id, :source_account_id)
    end
  end
end
