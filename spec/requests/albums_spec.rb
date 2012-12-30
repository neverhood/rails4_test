require 'spec_helper'

describe 'Albums' do

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe 'Create' do
    let(:album) { FactoryGirl.build(:standalone_album) }

    it 'creates new album' do
      visit user_albums_path(user)

      within '#new-album-modal' do
        fill_in 'album_name', with: album.name
        find('input[type="submit"]').click
      end

      page.should have_content(album.name)
      user.albums.count.should == 1
    end
  end

  describe 'Update' do
    let(:album) { FactoryGirl.create(:album, user: user) }
    let(:album_params) { { name: 'new album name' } }

    it 'updates album' do
      visit edit_album_path(album)

      fill_in 'album_name', with: album_params[:name]
      click_button I18n.t('common.submit')

      album.reload.name.should == album_params[:name]
    end
  end

end
