require "yaml"

class Tag

  def initialize(attributes = {})
    @title = attributes[:title]
    @description = attributes[:description]
    @image_file_name = attributes[:image_file_name]
  end

end
