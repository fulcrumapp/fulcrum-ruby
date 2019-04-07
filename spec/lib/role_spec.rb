require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::Role do
  include_context 'with client'
  include_context 'with resource'

  let(:resource) { client.roles }

  include_examples 'lists resource'
end
