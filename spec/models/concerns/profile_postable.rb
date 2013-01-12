require 'spec_helper'

shared_examples_for 'profile postable' do
  let(:factory) { "standalone_#{described_class.name.underscore}".to_sym }
  let(:post)   { FactoryGirl.build(factory) }

  it { should have_one(:profile_post) }

  describe 'Callbacks' do
    context 'Unpersisted' do
      it 'creates a profile post after create' do
        post.save

        post.reload.profile_post.should be_present
      end
    end

    context 'Persisted' do
      before { post.save }

      it 'destroys a profile post entry upon destroy' do
        post.destroy

        expect { post.profile_post.reload }.to raise_error
      end
    end
  end
end

describe ProfileComment do
  it_behaves_like 'profile postable'
end
