module Fulcrum
  class Changeset < Resource
    include Actions::List
    include Actions::Find
    include Actions::Create
    include Actions::Update

    def close(id, object={})
      call(:put, member_action(id, 'close'), attributes_for_object(object))[resource_name]
    end
  end
end
