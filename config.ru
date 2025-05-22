# frozen_string_literal: true

require 'rack/deflater'
require_relative './app/router'
require_relative './config/environment'
require_relative './app/middleware/error_handler'
require_relative './app/middleware/static_content'
require_relative './app/middleware/jwt_auth'
require_relative './app/middleware/json_content_type'

use ErrorHandler
use StaticContent,
    urls: ['/AUTHORS', '/openapi.yaml'],
    root: 'public'
use JwtAuth
use JsonContentTypeMiddleware
use Rack::Deflater, if: lambda { |env, _status, _headers, _body|
  accept_encoding = env['HTTP_ACCEPT_ENCODING'].to_s
  accept_encoding.include?('gzip')
}

run App::Router.new
