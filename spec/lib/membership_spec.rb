require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::Membership do
  include_context 'with client'
  include_context 'with resource'

  let(:resource) { client.memberships }

  include_examples 'lists resource'
end
