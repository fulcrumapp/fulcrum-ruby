require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::ChoiceList do
  include_context 'with client'
  include_context 'with resource'

  let(:resource) { client.choice_lists }

  include_examples 'list resource'
  include_examples 'find resource'
  include_examples 'create resource'
  include_examples 'update resource'
  include_examples 'delete resource'
end
