# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Partners', type: :request do
  let!(:material) { create(:material, name: 'wood') }
  let!(:partner_within_radius) do
    create(
      :partner,
      latitude: 40.7127,
      longitude: -74.0060,
      operating_radius: 10,
      materials: [material],
    )
  end
  let!(:partner_outside_radius) do
    create(
      :partner,
      latitude: 41.0000,
      longitude: -75.0000,
      operating_radius: 10,
      materials: [material],
    )
  end

  describe 'GET /api/v1/partners' do
    let(:lat) { 40.7128 }
    let(:lon) { -74.0060 }

    it 'returns partners sorted by rating and distance' do
      get '/api/v1/partners', params: { material: 'wood', lat: lat, lon: lon }

      expect(response).to have_http_status(:ok)

      json_response = response.parsed_body

      expect(json_response.size).to eq(1)
      expect(json_response.first['name']).to eq(partner_within_radius.name)
      expect(json_response.first['distance']).to be_present
      expect(json_response.first['rating']).to eq(partner_within_radius.rating)
      expect(json_response.first['materials'].pluck(:name)).to eq(partner_within_radius.materials.pluck(:name))
      expect(json_response.pluck(:id)).not_to include(partner_outside_radius.id)
    end

    it 'returns an empty array if no partners are within the radius' do
      get '/api/v1/partners', params: { material: 'metal', lat: lat, lon: lon }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to be_empty
    end
  end
end
