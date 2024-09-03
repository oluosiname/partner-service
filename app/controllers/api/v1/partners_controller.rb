# frozen_string_literal: true

module Api
  module V1
    class PartnersController < ApplicationController
      before_action :validate_customer_params, only: :index

      def index
        partners = Partner.best_matches(customer_params[:material], customer_params[:lat], customer_params[:lon])

        render json: partners, status: :ok
      end

      private

      def customer_params
        params.permit(:material, :lat, :lon, :square_meters, :phone_number)
      end

      def validate_customer_params
        return if [customer_params[:material], customer_params[:lat], customer_params[:lon]].all?(&:present?)

        render json: { error: 'Invalid request data' }, status: :bad_request
      end
    end
  end
end
