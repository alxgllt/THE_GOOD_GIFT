require "yaml"

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :select_tags ]

  def home
    tags_as_hashes = YAML.load_file(File.join(File.dirname(__FILE__), "../../db/tags.yml"))
    @tags_as_objects = tags_as_hashes.map { |tag| Tag.new(tag.symbolize_keys) }
  end

  def select_tags
    @cart = Cart.new
    @tag = Tag.new
    @product = Product.new
    tags_as_hashes = YAML.load_file(File.join(File.dirname(__FILE__), "../../db/tags.yml"))
    @tags_as_objects = tags_as_hashes.map { |tag| Tag.new(tag.symbolize_keys) }
  end

end
