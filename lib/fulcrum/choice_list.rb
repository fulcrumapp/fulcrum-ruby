module Fulcrum
  class ChoiceList < Resource
    include Actions::List
    include Actions::Find
    include Actions::Create
    include Actions::Update
    include Actions::Delete
  end
end
