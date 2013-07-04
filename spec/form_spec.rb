require 'spec_helper'

describe S3BrowserUploads::Form do
  [:region, :aws_access_key_id, :aws_secret_access_key, :aws_session_token, :bucket, :acl].each do |key|
    it "should set #{key} from hash passed to" do
      form = S3BrowserUploads::Form.new(key => 'foo')
      form.send(key).should == 'foo'
    end
  end
end