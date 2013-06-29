require 'spec_helper'

describe PhotoItem do

  it { should belong_to(:item) }
  it { should belong_to(:photo) }

  let(:photo_item) { PhotoItem.create(photo_id: 1, item_id: 1) }

  context 'Methods' do
    describe '#toggle_visibility!' do
      it 'should toggle visibility' do
        photo_item.toggle_visibility!

        photo_item.should_not be_visible
      end
    end
  end

end
