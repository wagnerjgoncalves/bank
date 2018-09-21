# frozen_string_literal: true

module API
  class AccountBalanceController < ApplicationController
    def show
      response = AccountService.balance(params[:id].to_i)
      status = response[:status] == :ok ? :ok : :bad_request

      render json: response, root: false, status: status
    end
  end
end
