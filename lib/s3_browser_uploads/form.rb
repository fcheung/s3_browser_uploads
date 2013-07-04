require 'time'
module S3BrowserUploads
  class Form
    attr_accessor :region, :aws_access_key_id, :aws_secret_access_key, :aws_session_token, :expires, :fields


    def bucket
      fields['bucket']
    end

    def bucket= value
      add_field 'bucket', value
    end

    def add_field key, value
      fields[key] = value
    end
    
    def initialize(options={})
      @fields = {}
      options.each {|key, value| public_send("#{key}=", value)}
    end
 
    def endpoint
      "https://#{bucket}.s3-#{region}.amazonaws.com"
    end

    def policy_document
      {
        'expires' => expires.xmlschema,
        'conditions' => []
      }
    end
  end
end