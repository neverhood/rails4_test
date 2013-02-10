require 'spec_helper'

describe City do
  it { should belong_to(:country) }
  it { should belong_to(:region)  }
end
