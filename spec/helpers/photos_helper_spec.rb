require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the PhotosHelper. For example:
#
# describe PhotosHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end

describe PhotosHelper do
  describe '#item_checkbox_for' do
    let(:item)       { double('Item', id: 1, name: 'face') }
    let(:photo_item) { double('PhotoItem', item_id: 1, visible?: true) }
    let(:photo)      { double('Photo', id: 1, photo_items: Array(photo_item)) }

    before { @user = double('User', sex: 'male', visible?: true) }

    it 'outputs check_box html' do
      translation = I18n.t("items.#{@user.sex}.#{item.name}")

      helper.item_checkbox_for(photo, item).should ==
        "<input checked=\"checked\" data-photo-id=\"#{photo.id}\" id=\"item-#{item.id}\" name=\"item-#{item.id}\" type=\"checkbox\" />#{translation}"
    end
  end
end
