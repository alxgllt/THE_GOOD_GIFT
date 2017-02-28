require "yaml"

class Card
  attr_reader :id, :title, :image_file_name

  def initialize(attributes = {})
    @id = attributes[:id]
    @title = attributes[:title]
    @image_file_name = attributes[:image_file_name]
  end

  def identifier
    @title.underscore.gsub(/\s/, "_")
  end

  def to_hash
    hash = {
      id: @id,
      title: @title,
      image_file_name: @image_file_name
    }
  end

end
