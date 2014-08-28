require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::Record do
  include_context 'with client'
  include_context 'with resource'

  let(:resource) { client.records }

  it_behaves_like "a resource"
end
