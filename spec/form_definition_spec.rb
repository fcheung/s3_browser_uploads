require 'spec_helper'

describe S3BrowserUploads::FormDefinition do

  let(:expires_at) {Time.now + 1800}
  [:region, :aws_access_key_id, :aws_secret_access_key, :aws_session_token, :bucket, :expires].each do |key|
    it "should set #{key} from hash passed to" do
      form = S3BrowserUploads::FormDefinition.new(key => 'foo')
      form.send(key).should == 'foo'
    end
  end

  describe 'endpoint' do
    it 'should return the url for the bucket' do
      S3BrowserUploads::FormDefinition.new(:region => 'eu-west-1', :bucket => 'some-bucket').endpoint.should  ==
        "https://some-bucket.s3-eu-west-1.amazonaws.com"
    end
  end

  describe 'aws_session_token' do
    it 'should be added as the x-amz-security-token field' do
      form = S3BrowserUploads::FormDefinition.new(:region => 'eu-west-1', :bucket => 'some-bucket', :aws_session_token => 'token')
      form.fields['x-amz-security-token'].should == 'token'
      form.conditions['x-amz-security-token'].should == {'x-amz-security-token' => 'token'}
    end
  end
  describe 'encoded_policy' do
    subject { S3BrowserUploads::FormDefinition.new(:region => 'eu-west-1', :bucket => 'some-bucket', :expires => expires_at)}

    its(:encoded_policy) {should == Base64.strict_encode64(subject.policy_document.to_json)}
    its(:encoded_policy) {should_not include("\n") }

  end

  describe 'signature' do
    #base64 hmac of the encoded policy
    subject { S3BrowserUploads::FormDefinition.new(:aws_secret_access_key => '123XYZ', :region => 'eu-west-1', :bucket => 'some-bucket', :expires => expires_at)}
    its(:signature) {should == Base64.strict_encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), '123XYZ', subject.encoded_policy))}
    context 'with sample data' do
      subject do 
        form = S3BrowserUploads::FormDefinition.new(:aws_secret_access_key => '123XYZ', :region => 'eu-west-1', :bucket => 'some-bucket', :expires => Time.utc(2012,1,1,1,1,1))
        form.add_field 'acl', 'public-read'
        form.add_condition 'key', 'starts-with' => 'users/fred/'
        form
      end
      its(:signature) {should == '9ea96Cgm8qqXa6HcE/nn2mN3U90='}
    end

  end

  describe 'policy_document' do
    let(:form) { S3BrowserUploads::FormDefinition.new(:region => 'eu-west-1', :bucket => 'some-bucket', :expires => expires_at)}

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

    context 'with a starts-with condition' do
      it 'should have the condition' do
        form.add_condition 'key', 'starts-with' => 'abc'
        form.policy_document['conditions'].should =~ [{'bucket' => 'some-bucket'}, ['starts-with', '$key', 'abc']]
      end
    end


    context 'with a content-length condition' do
      it 'should have the condition' do
        form.restrict_content_length 0..1024
        form.policy_document['conditions'].should =~ [{'bucket' => 'some-bucket'}, ['content-length-range', 0,1024]]
      end
    end

    context 'with an eq condition' do
      it 'should have the condition' do
        form.add_condition 'key', 'eq' => 'abc'
        form.policy_document['conditions'].should =~ [{'bucket' => 'some-bucket'}, ['eq', '$key', 'abc']]
      end
    end

    context 'when a field has been added' do
      it 'should add a strict match condition on the field' do
        form.add_field('acl', 'private')
        form.policy_document['conditions'].should == [{'bucket' => 'some-bucket'}, {'acl' => 'private'}]
      end

      it 'should the condition to be overriden' do
        form.add_field('key', 'users/bob/${filename}')
        form.add_condition('key', 'starts-with' => 'users/bob/')
        form.policy_document['conditions'].should == [{'bucket' => 'some-bucket'}, ['starts-with', '$key', 'users/bob/']]
      end
    end
  end
end