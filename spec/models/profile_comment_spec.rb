require 'spec_helper'

describe ProfileComment do
  it { should ensure_length_of(:body).is_at_least(1).is_at_most(1000) }
end
