# frozen_string_literal: true

module Validation
  def self.required_fields(data, required_keys)
    missing = required_keys.select { |key| data[key].nil? || data[key].to_s.strip.empty? }
    missing.map { |key| "#{key} is required" }
  end
end
