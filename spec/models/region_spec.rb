require 'spec_helper'

describe Region do
  it { should belong_to(:country) }
  it { should have_many(:cities)  }
end
