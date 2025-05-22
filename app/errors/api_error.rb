# frozen_string_literal: true

module Errors
  class ApiError < StandardError
    attr_reader :status_code

    def initialize(message, status_code)
      super(message)
      @status_code = status_code
    end
  end

  class ValidationError < ApiError
    def initialize(message)
      super(message, 400)
    end
  end

  class NotFoundError < ApiError
    def initialize(message)
      super(message, 404)
    end
  end

  class UnauthorizedError < ApiError
    def initialize(message)
      super(message, 401)
    end
  end

  class InternalServerError < ApiError
    def initialize(message)
      super(message, 500)
    end
  end
end
