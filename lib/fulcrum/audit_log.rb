module Fulcrum
  class AuditLog < Resource
    include Actions::List
    include Actions::Find
  end
end