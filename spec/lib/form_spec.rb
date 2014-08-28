require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::Form do
  include_context 'with client'
  include_context 'with resource'

  let(:resource) { client.forms }

  it_behaves_like "a resource"
end
