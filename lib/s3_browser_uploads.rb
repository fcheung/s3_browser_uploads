require "s3_browser_uploads/version"
require "s3_browser_uploads/form_definition"

module S3BrowserUploads
  # Your code goes here...
end

if defined?(Rails)
  require 's3_browser_uploads/railtie'
end