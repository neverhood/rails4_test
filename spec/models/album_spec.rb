require 'spec_helper'

describe Album do
  it { should belong_to(:user) }
  it { should have_one(:cover_photo) }

  it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
  it { should validate_uniqueness_of(:transliterated_name).scoped_to(:user_id) }
  it { should ensure_length_of(:name).is_at_least(1).is_at_most(100) }
  it { should ensure_length_of(:description).is_at_most(5000) }

  describe 'Callbacks' do
    let(:album) { FactoryGirl.build(:album) }

    it 'saves transliterated name' do
      album.save
      album.transliterated_name.should == album.name.parameterize
    end
  end
end
