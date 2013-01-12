require 'spec_helper'

describe User do

  describe 'Validations' do
    let(:user) { FactoryGirl.build(:user) }

    it { should validate_uniqueness_of(:login) }
    it { should ensure_length_of(:login).is_at_least(3).is_at_most(20) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:name)    }

    it { should have_many(:albums) }
    it { should have_many(:photos) }
    it { should have_many(:news_feed_entries) }
    it { should have_one(:profile) }
    it { should have_many(:profile_posts) }

    describe 'Login format validation' do
      before { user.should be_valid }

      context 'valid' do
        it 'recognizes a valid login' do
          %w( Username user_name user-name ).each do |login|
            user.login = login
            user.should be_valid
          end
        end
      end

      context 'invalid' do
        it 'recognizes invalid login' do
          %w( digits99 -user_name user-name- ==== ++anya++ ).each do |login|
            user.login = login
            user.should be_invalid
          end
        end
      end
    end
  end

  describe 'Methods' do
    let(:user) { FactoryGirl.build(:user) }

    describe '#sex' do
      it 'treats male:true as male' do
        user.male = true
        user.sex.should == :male
      end

      it 'treats male:false as female' do
        user.male = false
        user.sex.should == :female
      end
    end
  end

  describe 'Callbacks' do
    let(:user) { FactoryGirl.build(:user) }

    it 'Downcases login' do
      user.update_attributes(login: 'UPPERCASE')
      user.reload.login.should == 'uppercase'
    end

    it 'Creates profile' do
      user.save
      user.profile.should be_present
    end
  end

end
