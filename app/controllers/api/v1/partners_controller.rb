# frozen_string_literal: true

module Api
  module V1
    class PartnersController < ApplicationController
      def index
        partners = Partner.best_matches(customer_params[:material], customer_params[:lat], customer_params[:lon])

        render json: partners, status: :ok
      end

      private

      def customer_params
        params.permit(:material, :lat, :lon, :square_meters, :phone_number)
      end
    end
  end
end
