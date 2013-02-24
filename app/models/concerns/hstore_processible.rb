# doesn't seem to be a right place for this one
#

require 'active_support/concern'

module HstoreProcessible
  extend ActiveSupport::Concern

  module ClassMethods
    attr_reader :hstore_accessors_with_options

    def uses_hstore_accessor hstore_key, options = {}
      raise "Invalid attribute name: #{key}" unless column_names.include?(hstore_key.to_s)

      options.slice! :with
      options[:with].stringify_keys!

      @hstore_accessors = (@hstore_conditions || []).push(hstore_key.to_sym => options)

      _define_after_initialize_callback_for_hstore hstore_key, options
      _define_before_update_callback_for_hstore hstore_key, options
    end

    private

    def _define_after_initialize_callback_for_hstore hstore_key, options
      after_initialize do
        defaults = Hash[ options[:with].map { |key, key_options| [ key, key_options[:default] ] } ]

        typecasted_hstore = defaults.merge(read_attribute(hstore_key) || {})

        typecasted_hstore.each do |key, value|
          value_type = options[:with][key].try(:[], :type).to_s
          value_default = options[:with][key].try(:[], :default)

          next if value_type.blank? or ( value_type != 'Boolean' and typecasted_hstore[key].is_a?(value_type.constantize) )
          next if value == value_default

          case value_type
          when 'Fixnum' then typecasted_hstore[key] = value.to_i
          when 'Boolean' then typecasted_hstore[key] = value == 'true'
          when 'Date' then typecasted_hstore[key] = value.to_date rescue nil
          when 'Time' then typecasted_hstore[key] = value.to_time rescue nil
          when 'Hash' then typecasted_hstore[key] = JSON.parse(value) rescue options[:with][key].try(:[], :default)
          when 'Array' then typecasted_hstore[key] = JSON.parse(value) rescue options[:with][key].try(:[], :default)
          end
        end

        self.send :"#{hstore_key}=", typecasted_hstore
      end
    end

    def _define_before_update_callback_for_hstore hstore_key, options
      before_update do
        hstore_attributes = read_attribute(hstore_key)
        hstore_hash_attributes = options[:with].select { |key, key_options| key_options[:type].present? and key_options[:type] == 'Hash' }
        hstore_array_attributes = options[:with].select { |key, key_options| key_options[:type].present? and key_options[:type] == 'Array' }

        hstore_hash_attributes.each do |key, key_options|
          hstore_attributes[key] = hstore_attributes[key].is_a?(Hash) ? JSON.dump(hstore_attributes[key]) : nil
        end

        hstore_array_attributes.each do |key, key_options|
          hstore_attributes[key] = hstore_attributes[key].is_a?(Array) ? JSON.dump(hstore_attributes[key]) : nil
        end

        hstore_attributes = hstore_attributes.keep_if { |key, value| not value.nil? }
      end
    end
  end
end


