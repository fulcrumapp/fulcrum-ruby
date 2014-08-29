require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::Project do
  include_context 'with client'
  include_context 'with resource'

  let(:resource) { client.projects }

  include_examples 'list resource'
  include_examples 'find resource'
end
