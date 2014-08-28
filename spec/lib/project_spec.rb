require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::Project do
  include_context 'with client'
  include_context 'with resource'

  let(:resource) { client.projects }

  it_behaves_like "a resource"
end
