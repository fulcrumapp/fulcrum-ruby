module Fulcrum
  class Layer < Resource
    include Actions::List
    include Actions::Find
  end
end
