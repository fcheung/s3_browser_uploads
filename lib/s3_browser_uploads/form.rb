module S3BrowserUploads
  class Form
    attr_accessor :region, :aws_access_key_id, :aws_secret_access_key, :aws_session_token, :bucket, :acl
 
    def initialize(options={})
      options.each {|key, value| public_send("#{key}=", value)}
    end
 
    def endpoint
      "https://#{bucket}.s3-#{region}.amazonaws.com"
    end
  end
end