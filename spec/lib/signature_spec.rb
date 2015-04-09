require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::Signature do
  let(:test_file) { './spec/data/test.png' }

  include_context 'with client'
  include_context 'with media resource'

  let(:resource) { client.signatures }

  include_examples 'lists resource'
  include_examples 'finds resource'
  include_examples 'creates resource'
end
