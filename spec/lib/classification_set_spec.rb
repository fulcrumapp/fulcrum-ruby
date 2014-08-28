require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::ClassificationSet do
  include_context 'with client'
  include_context 'with resource'

  let(:resource) { client.classification_sets }

  it_behaves_like "a resource"
end

