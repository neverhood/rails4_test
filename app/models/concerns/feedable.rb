require 'active_support/concern'

module Feedable
  extend ActiveSupport::Concern

  module ClassMethods
    # respects instance context
    attr_reader :feed_conditions

    def feeds_if(conditions)
      @feed_conditions = (@feed_conditions || []).push(conditions)

      # We need to reload the callback since we specify the conditions after callback was defined
      _create_callbacks.find { |callback| callback.respond_to?(:filter) and callback.filter == :_feed_callback }.tap do |callback|
        callback.options[:if].push @feed_conditions
        callback.send :recompile_options!
      end
    end
  end

  included do
    has_one :news_feed_entry, -> entry { where(entry_type: POLYMORPHIC_INTEGER_TYPES.invert[entry.class.name]) }, foreign_key: 'entry_id', dependent: :destroy

    after_create :_feed_callback
  end

  private

  def _feed_callback
    create_news_feed_entry(user_id: user_id)
  end
end
