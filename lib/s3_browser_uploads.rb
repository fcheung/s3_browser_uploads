require "s3_browser_uploads/version"
require "s3_browser_uploads/form"

module S3BrowserUploads
  # Your code goes here...
end

if defined?(Rails)
  require 's3_browser_uploads/railtie'
end