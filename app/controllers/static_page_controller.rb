require 'rails/application_controller'

class StaticPageController < Rails::ApplicationController
  def index
    render file: Rails.root.join('public', 'idea_index.html')
  end
end