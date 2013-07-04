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
      add_condition key, value
      value
    end

    def add_condition key, condition
      @conditions[key] = case condition
      when String then {key => condition} 
      when Hash then 
        [condition.keys.first, "$#{key}", condition.values.first]
      else
        raise ArgumentError, "unknown condition type #{condition}"
      end
    end

    def initialize(options={})
      @fields = {}
      @conditions = {}
      options.each {|key, value| public_send("#{key}=", value)}
    end
 
    def endpoint
      "https://#{bucket}.s3-#{region}.amazonaws.com"
    end

    def policy_document
      {
        'expires' => expires.xmlschema,
        'conditions' => @conditions.values
      }
    end

  end
end