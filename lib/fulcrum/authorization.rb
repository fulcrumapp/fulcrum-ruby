module Fulcrum
  class Authorization < Resource
    include Actions::List
    include Actions::Find
    include Actions::Update
    include Actions::Delete

    def regenerate(id)
      call(:post, member_action(id, 'regenerate'))[resource_name]
    end
  end
end
