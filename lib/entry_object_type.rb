# This one is made to make rails polymorphic _type column store an integer instead of string
# bacause of a huge number of table records.
# POLYMORHPIC_INTEGER_TYPES is initialized in config/initializers/polymorphic_integer_types
#
# It overrides association_class to constantize the looked up value
#

module EntryObjectType
  module IntegerTypeValue
    def association_class
      POLYMORPHIC_INTEGER_TYPES[entry_type].constantize
    end
  end
end
