# frozen_string_literal: true

require 'singleton'
require_relative '../models/product'
require_relative '../errors/api_error'
require_relative './tasks_service'

class ProductsService
  include Singleton

  def initialize
    @products = []
    @next_id = 1
  end

  def all
    @products
  end

  def create_async(name)
    TasksService.instance.run_async('create', 'product', method(:create), [name])
  end

  def find(id)
    @products.find { |p| p.id == id }
  end

  def create(name)
    sleep(5) # Simulate creation time of 5 seconds
    product = Product.new(id: @next_id, name: name)
    # Check if name is already taken
    raise Errors::ValidationError, 'Name already taken' if @products.any? { |product| product.name == name }

    @products << product
    @next_id += 1
    product
  end
end
