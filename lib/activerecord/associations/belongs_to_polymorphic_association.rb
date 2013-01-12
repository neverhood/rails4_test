module ActiveRecord

  module Associations
    class BelongsToPolymorphicAssociation < BelongsToAssociation
      def klass
        type = POLYMORPHIC_INTEGER_TYPES[owner[reflection.foreign_type]]
        type.presence && type.constantize
      end
    end
  end

end
