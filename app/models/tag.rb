require "yaml"

class Tag

  def initialize(attributes = {})
    @title = attributes[:title]
    @description = attributes[:description]
    @image_file_name = attributes[:image_file_name]
  end

# # to load the yaml (you get an array of hashes):
# tags_as_hashes = YAML.load_file(File.join(File.dirname(__FILE__), "tags.yml"))

# # to have an array of Tag objects:
# @tags_as_objects = tags_as_hashes.map { |tag| Tag.new(tag) }

end
