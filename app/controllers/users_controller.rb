# frozen_string_literal: true

require 'json'
require_relative '../services/users_service'
require_relative '../utils/validation'

module Controllers
  class UsersController
    def self.create(req)
      data = begin
        JSON.parse(req.body.read)
      rescue StandardError
        {}
      end

      errors = Validation.required_fields(data, %w[email password])
      raise Errors::ValidationError, errors.to_json unless errors.empty?

      user = UsersService.instance.create(data['name'], data['email'], data['password'])
      [201, {}, [user.to_json]]
    end

    def self.all(_req)
      users = UsersService.instance.all
      [200, {}, [users.to_json]]
    end

    def self.get(req)
      id = req.path_info.split('/').last.to_i
      user = UsersService.instance.find(id)
      raise Errors::NotFoundError, "User with id #{id} not found" unless user

      [200, {}, [user.to_json]]
    end
  end
end
