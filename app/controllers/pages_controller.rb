class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :select_tags ]

  def home
  end

  def select_tags
  end
end
