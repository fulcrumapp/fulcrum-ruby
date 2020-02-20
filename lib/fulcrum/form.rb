module Fulcrum
  class Form < Resource
    include Actions::List
    include Actions::Find
    include Actions::Create
    include Actions::Update
    include Actions::Delete

    def history(id, params = {})
      result = call(:get, member_action(id, 'history'), params)

      Page.new(result, resources_name)
    end

  end
end
