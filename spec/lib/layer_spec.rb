require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::Layer do
  include_context 'with client'
  include_context 'with resource'

  let(:resource) { client.layers }

  include_examples 'list resource'
  include_examples 'find resource'
end
