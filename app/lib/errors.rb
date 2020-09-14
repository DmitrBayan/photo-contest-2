# frozen_string_literal: true

module Errors
  class Base < StandardError
    attr_reader :message, :status, :details

    def initialize(custom_message: nil, custom_status: nil, details: nil)
      @message = custom_message || 'Unprocessed error'
      @status = custom_status || :bad_request
      @details = details
    end

    def name
      self.class.name
    end
  end

  class InvalidCredentials < Base
    def status
      :unauthorized
    end

    def message
      'You provide invalid user token'
    end
  end

  class InvalidRequestData < Base
    def status
      :bad_request
    end

    def message
      'Invalid request'
    end
  end

  class Unauthenticated < Base
    def message
      'Authentication is required to perform this request'
    end

    def status
      :unauthorized
    end
  end

  class NotAllowed < Base
    def message
      'You are not allowed to do this.'
    end

    def status
      :method_not_allowed
    end
  end

  class NotFound < Base
    def message
      'Resource not found'
    end

    def status
      :not_found
    end
  end
end
