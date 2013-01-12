require 'spec_helper'

shared_examples_for 'feedable' do
  let(:factory) { "standalone_#{described_class.name.underscore}".to_sym }
  let(:entry)   { FactoryGirl.build(factory) }

  it { should have_one(:news_feed_entry) }

  describe 'Callbacks' do
    context 'Unpersisted' do
      it 'creates a news feed entry after create' do
        entry.save

        entry.reload.news_feed_entry.should be_present
      end
    end

    context 'Persisted' do
      before { entry.save }

      it 'destroys a news feed entry upon destroy' do
        entry.destroy

        expect { entry.news_feed_entry.reload }.to raise_error
      end
    end
  end
end

describe Photo do
  it_behaves_like 'feedable'
end
