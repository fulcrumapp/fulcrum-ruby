module Fulcrum
  class Project < Resource
    include Actions::List
    include Actions::Find
  end
end

