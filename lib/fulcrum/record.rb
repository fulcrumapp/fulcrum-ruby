module Fulcrum
  class Record < Resource
    include Actions::List
    include Actions::Find
    include Actions::Create
    include Actions::Update

    def delete(id, changeset_id=nil)
      record_attributes = {}
      record_attributes[:changeset_id] = changeset_id if changeset_id

      call(:delete, member(id), attributes_for_object(record_attributes))
    end
  end
end
