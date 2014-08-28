module Fulcrum
  class Page
    attr_accessor :objects
    attr_accessor :current_page
    attr_accessor :total_pages
    attr_accessor :total_count
    attr_accessor :per_page

    def initialize(data, resources_name)
      self.objects      = data[resources_name]
      self.current_page = data['current_page']
      self.total_pages  = data['total_pages']
      self.total_count  = data['total_count']
      self.per_page     = data['per_page']
    end
  end
end
