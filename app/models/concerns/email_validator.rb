# frozen_string_literal: true

module EmailValidator
  extend ActiveSupport::Concern

  included do
    EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.freeze

    def validate_email
      errors.add :email, 'has invalid format' unless email =~ EMAIL_FORMAT
    end

    validate :validate_email, if: :email_present?

    private

    def email_present?
      email.present?
    end
  end
end
