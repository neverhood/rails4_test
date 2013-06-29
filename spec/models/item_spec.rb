require 'spec_helper'
require "#{ Rails.root }/db/seeds/items"

describe Item do

  context 'Class Methods' do

    describe '#json' do
      it 'provides all items json' do
        described_class.json.should == described_class.all.to_json
      end
    end

  end

  context 'Scopes' do
    describe '#male' do
      it 'includes male items only' do
        described_class.male.where(male: false).count.should be_zero
      end
    end

    describe '#female' do
      it 'includes female items only' do
        described_class.female.where(male: true).count.should be_zero
      end
    end
  end

end
