require 'active_support/concern'

module Respondable
  extend ActiveSupport::Concern

  module ClassMethods
    def respondable?; true; end
  end

  included do
    has_one :response_entry, -> entry { where(entry_type: POLYMORPHIC_INTEGER_TYPES.invert[entry.class.name]) }, foreign_key: 'entry_id', dependent: :destroy
  end
end
