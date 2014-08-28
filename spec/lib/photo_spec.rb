require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::Photo do
  let(:test_file) { './spec/data/test.jpg' }

  include_context 'with client'
  include_context 'with media resource'

  let(:resource) { client.photos }

  it_behaves_like "a resource"
end
