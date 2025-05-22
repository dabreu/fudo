# frozen_string_literal: true

class Product
  attr_reader :id, :name

  def initialize(id:, name:)
    @id = id
    @name = name
  end

  def to_h
    { id: id, name: name }
  end

  def to_json(*_args)
    to_h.to_json
  end
end
