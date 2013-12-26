require 'time'
require 'base64'
require 'json'
module S3BrowserUploads
  class FormDefinition
    attr_accessor :region, :aws_secret_access_key, :expires, :fields, :conditions


    def aws_access_key_id= value
      fields['AWSAccessKeyID'] = value #access key id is not included in the policy
    end

    def aws_access_key_id
      fields['AWSAccessKeyID'] #access key id is not included in the policy
    end


    def aws_session_token
      fields['x-amz-security-token']
    end

    def aws_session_token= value
      add_field 'x-amz-security-token', value
    end


    def bucket
      fields['bucket']
    end

    def bucket= value
      add_field 'bucket', value
    end

    def add_field key, value
      fields[key] = value
      add_condition key, value
      value
    end

    def add_condition key, condition
      @conditions[key] = case condition
      when String then {key => condition} 
      when Hash then 
        [condition.keys.first, "$#{key}", condition.values.first]
      when Range then
        [key, condition.begin, condition.end]
      else
        raise ArgumentError, "unknown condition type #{condition}"
      end
    end

    def restrict_content_length range
      add_condition 'content-length-range', range
    end

    def initialize(options={})
      @fields = {}
      @conditions = {}
      options.each {|key, value| public_send("#{key}=", value)}
      @digest = OpenSSL::Digest.new('sha1')
      @hmac = lambda {|data| OpenSSL::HMAC.digest(@digest, @aws_secret_access_key, data)}
    end

    def signature
      Base64.strict_encode64(@hmac[encoded_policy])
    end

    def endpoint
      "https://#{bucket}.s3-#{region}.amazonaws.com"
    end

    def encoded_policy
      Base64.strict_encode64(policy_document.to_json)
    end

    def policy_document
      {
        'expiration' => expires.utc.xmlschema,
        'conditions' => @conditions.values
      }
    end

  end
end