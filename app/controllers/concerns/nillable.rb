# stupidiest name ever?
#
# TODO: tests
#

require 'active_support/concern'

module Nillable
  extend ActiveSupport::Concern

  module ClassMethods
    # ==== Turns empty strings into nils ====
    #
    # Example:
    #   class UsersController < ApplicationController
    #     before_filter :authenticate_user!
    #     ...
    #     nullifies user: { details: [ :country_id, :city_id ] }, only: [ :create, :update ]
    #     # OR
    #     nullifies user: [ :login, :name ]
    #     # OR
    #     nullifies :username, :password
    #
    #     ...
    #   end
    def nullifies attributes
      raise 'Hash or Array expected' unless [Hash, Array].include?(attributes.class)

      options = {}
      if attributes.is_a? Hash
        options[:only] = attributes.delete(:only) if attributes[:only].present?
        options[:except] = attributes.delete(:except) if attributes[:except].present?
      end

      before_filter(options) do |controller|
        if attributes.is_a?(Hash)
          attributes.keys.each { |key| controller.class.send(:_nullify_params_under_namespace, params[key], attributes[key]) }
        else
          controller.class.send(:_nullify_params_under_namespace, params, attributes)
        end
      end
    end

    private

    # recursive stuff
    def _nullify_params_under_namespace namespaced_params, attrs
      return unless [Hash, Array].include?(attrs.class)

      if attrs.is_a? Array
        attrs.map!(&:to_s)

        namespaced_params.each { |key, value| namespaced_params[key] = nil if value.empty? and attrs.include?(key) }
      else
        attrs.keys.each { |key| _nullify_params_under_namespace(namespaced_params[key], attrs[key]) }
      end
    end
  end

  included do
  end
end
