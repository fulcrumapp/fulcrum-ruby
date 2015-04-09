require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::Audio do
  let(:test_file) { './spec/data/test.m4a' }

  include_context 'with client'
  include_context 'with media resource'

  let(:resource) { client.audio }

  include_examples 'lists resource'
  include_examples 'finds resource'
  include_examples 'creates resource'
end
