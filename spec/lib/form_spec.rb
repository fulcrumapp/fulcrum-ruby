require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::Form do
  include_context 'with client'
  include_context 'with resource'

  let(:resource) { client.forms }

  include_examples 'lists resource'
  include_examples 'finds resource'
  include_examples 'creates resource'
  include_examples 'updates resource'
  include_examples 'deletes resource'
end
