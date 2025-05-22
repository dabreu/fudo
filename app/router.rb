# frozen_string_literal: true

require_relative './controllers/auth_controller'
require_relative './controllers/users_controller'
require_relative './controllers/products_controller'
require_relative './controllers/tasks_controller'
require_relative './errors/api_error'

module App
  class Router
    def call(env)
      req = Rack::Request.new(env)
      method = req.request_method
      path   = req.path_info

      if method == 'POST' && path == '/api/login'
        Controllers::AuthController.login(req)

      elsif method == 'POST' && path == '/api/users'
        Controllers::UsersController.create(req)
      elsif method == 'GET' && path == '/api/users'
        Controllers::UsersController.all(req)
      elsif method == 'GET' && path =~ %r{^/api/users/\d+$}
        Controllers::UsersController.get(req)

      elsif method == 'POST' && path == '/api/products'
        Controllers::ProductsController.create_async(req)
      elsif method == 'GET' && path == '/api/products'
        Controllers::ProductsController.all(req)
      elsif method == 'GET' && path =~ %r{^/api/products/\d+$}
        Controllers::ProductsController.get(req)

      elsif method == 'GET' && path == '/api/tasks'
        Controllers::TasksController.all(req)
      elsif method == 'GET' && path =~ %r{^/api/tasks/\d+/status$}
        Controllers::TasksController.get(req)

      else
        raise Errors::NotFoundError, "Route not found: #{method} #{path}"
      end
    end
  end
end
