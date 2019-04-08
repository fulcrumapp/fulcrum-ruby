require 'spec_helper'

include Support::ResourceExamples

describe Fulcrum::AuditLog do
  include_context 'with client'
  include_context 'with resource'

  let(:resource) { client.audit_logs }

  include_examples 'lists resource'
  include_examples 'finds resource'
end
