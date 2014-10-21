module Fulcrum
  class Record < Resource
    include Actions::List
    include Actions::Find
    include Actions::Create
    include Actions::Update

    def delete(id, changeset_id=nil)
      call(:delete, member(id), attributes_for_object(changeset_id: changeset_id))
    end
  end
end
