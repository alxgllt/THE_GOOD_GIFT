require "yaml"

class Tag
  attr_reader :title, :description, :image_file_name

  def initialize(attributes = {})
    @title = attributes[:title]
    @description = attributes[:description]
    @image_file_name = attributes[:image_file_name]
  end

end
