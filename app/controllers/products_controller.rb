# frozen_string_literal: true

require 'json'
require_relative '../services/products_service'
require_relative '../utils/validation'

module Controllers
  class ProductsController
    def self.create_async(req)
      data = begin
        JSON.parse(req.body.read)
      rescue StandardError
        {}
      end

      errors = Validation.required_fields(data, ['name'])
      raise Errors::ValidationError, errors.to_json unless errors.empty?

      task = ProductsService.instance.create_async(data['name'])
      [202, { 'retry-after' => '300', 'location' => "/api/tasks/#{task.id}/status/" }, [task.to_json]]
    end

    def self.all(_req)
      products = ProductsService.instance.all
      [200, {}, [products.to_json]]
    end

    def self.get(req)
      id = req.path_info.split('/').last.to_i
      product = ProductsService.instance.find(id)
      raise Errors::NotFoundError, "Product with id #{id} not found" unless product

      [200, {}, [product.to_json]]
    end
  end
end
