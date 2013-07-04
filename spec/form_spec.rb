require 'spec_helper'

describe S3BrowserUploads::Form do
  [:region, :aws_access_key_id, :aws_secret_access_key, :aws_session_token, :bucket, :acl, :expires].each do |key|
    it "should set #{key} from hash passed to" do
      form = S3BrowserUploads::Form.new(key => 'foo')
      form.send(key).should == 'foo'
    end
  end

  describe 'endpoint' do
    it 'should return the url for the bucket' do
      S3BrowserUploads::Form.new(:region => 'eu-west-1', :bucket => 'some-bucket').endpoint.should  ==
        "https://some-bucket.s3-eu-west-1.amazonaws.com"
    end
  end
end