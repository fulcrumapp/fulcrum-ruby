require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::Webhook do
  include_context 'with client'
  include_context 'with resource'

  let(:resource) { client.webhooks }

  include_examples 'lists resource'
  include_examples 'finds resource'
  include_examples 'creates resource'
  include_examples 'updates resource'
  include_examples 'deletes resource'
end
