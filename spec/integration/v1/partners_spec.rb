# frozen_string_literal: true

# spec/integration/partners_spec.rb

require 'swagger_helper'

RSpec.describe 'api/v1/partners', openapi_spec: 'v1/swagger.yaml', type: :request do
  path '/api/v1/partners' do
    get 'Retrieves a list of matching partners' do
      tags 'Partners'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :material, in: :query, type: :string, description: 'Materia for the floor', required: true
      parameter name: :lat, in: :query, type: :string, description: 'Latitude of the house Address', required: true
      parameter name: :lon, in: :query, type: :string, description: 'Longitude of the House Address', required: true
      parameter name: :square_meters,
        in: :query,
        type: :string,
        description: 'Square meters of the floor',
        required: false
      parameter name: :phone_number,
        in: :query,
        type: :string,
        description: 'Phone number for the partner to contact the customer',
        required: false

      response '200', 'partners found' do
        let(:partner_material) { create(:partner_material) }
        let(:partner) { partner_material.partner }
        let(:material) { partner_material.material.name }
        let(:lat) { partner.latitude }
        let(:lon) { partner.longitude }

        schema type: :array, items: { '$ref' => '#/components/schemas/partner' }

        run_test! do |response|
          data = JSON.parse(response.body)

          expect(response).to have_http_status(:ok)

          expect(data.size).to eq(1)
          expect(data.first['name']).to eq(partner.name)
          expect(data.first['distance']).to be_present
          expect(data.first['rating']).to eq(partner.rating)
          expect(data.first['materials'].pluck('name')).to eq([partner_material.material.name])
        end
      end

      response '400', 'invalid request' do
        let(:partner_material) { create(:partner_material) }
        let(:partner) { partner_material.partner }
        let(:material) { partner_material.material.name }
        let(:lat) { nil }
        let(:lon) { nil }

        run_test!
      end
    end
  end
end
