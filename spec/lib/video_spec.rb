require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::Video do
  let(:test_file) { './spec/data/test.mp4' }

  include_context 'with client'
  include_context 'with media resource'

  let(:resource) { client.videos }

  include_examples 'list resource'
  include_examples 'find resource'
  include_examples 'create resource'
end
