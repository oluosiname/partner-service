# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.to_s + '/swagger'

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Partner Service API V1',
        version: 'v1',
      },
      paths: {},
      components: {
        schemas: {
          partner: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              latitude: { type: :number },
              longitude: { type: :number },
              rating: { type: :number },
              operating_radius: { type: :number },
              distance: { type: :number },
              materials: {
                type: :array,
                items: { '$ref' => '#/components/schemas/material' },
              },
            },
          },
          material: {
            type: :object,
            properties: {
              name: { type: :string },
            },
          },
        },
      },
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Development Server',
        },
      ],
    },
  }

  config.swagger_format = :yaml
end
