module S3BrowserUploads
  class Railtie < ::Rails::Railtie
    initializer "will_paginate" do |app|
      ActiveSupport.on_load :action_view do
        require 's3_browser_uploads/view_helpers'
      end
    end
  end
end