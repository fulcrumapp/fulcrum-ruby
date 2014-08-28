require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::ChoiceList do
  include_context 'with client'
  include_context 'with resource'

  let(:resource) { client.choice_lists }

  it_behaves_like "a resource"
end
