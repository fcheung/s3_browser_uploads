require 'spec_helper'

describe S3BrowserUploads::Form do

  let(:expires_at) {Time.now + 1800}
  [:region, :aws_access_key_id, :aws_secret_access_key, :aws_session_token, :bucket, :expires].each do |key|
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

  describe 'policy_document' do
    let(:form) { S3BrowserUploads::Form.new(:region => 'eu-west-1', :bucket => 'some-bucket', :expires => expires_at)}

    it 'should contain expires and conditions' do
      form.policy_document.keys.should =~ %w(conditions expires)
    end

    it 'should set expires to the xml schema representation of the expiry date' do
      form.policy_document['expires'].should == expires_at.xmlschema
    end

    context 'with no conditions added' do
      it 'should have a condition on the bucket' do
        form.policy_document['conditions'].should == [{'bucket' => 'some-bucket'}]
      end
    end

    context 'with a strict condition added' do
      it 'should have the condition' do
        form.add_condition 'key', 'abc'
        form.policy_document['conditions'].should =~ [{'bucket' => 'some-bucket'}, {'key' => 'abc'}]
      end
    end

    context 'when a field has been added' do
      it 'should add a strict match condition on the field' do
        form.add_field('acl', 'private')
        form.policy_document['conditions'].should == [{'bucket' => 'some-bucket'}, {'acl' => 'private'}]
      end
    end
  end
end