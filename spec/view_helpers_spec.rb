require 'spec_helper'

describe S3BrowserUploads::ViewHelpers, :type => 'helper' do
  include Capybara::RSpecMatchers
  include RSpec::Rails::HelperExampleGroup
  let(:form_definition) do 
    S3BrowserUploads::FormDefinition.new(:region => 'eu-west-1', 
                                         :bucket => 'some-bucket',
                                         :expires => Time.now + 1800,
                                         :aws_access_key_id => 'AnAccessKey',
                                         :aws_secret_access_key => 'ASecretKey')
  end

  describe 's3_form' do
    let(:content) {helper.s3_form(form_definition) {}}

    describe 'form tag' do
      subject {Capybara.string(content).find('form')}
      its([:action]) { should == form_definition.endpoint }
      its([:enctype]) { should == 'multipart/form-data' }
      its([:method]) { should == 'POST' }
    end

    describe 'form contents' do
      subject {content}
      it 'should include a utf8 enforcer tag' do
        should have_hidden_input("x-ignore-utf8").with_value("\u2713")
      end

      it { should  have_hidden_input('AWSAccessKeyID').with_value("AnAccessKey") } 
      it { should  have_hidden_input('signature').with_value(form_definition.signature) } 
      it { should  have_hidden_input('policy').with_value(form_definition.encoded_policy) } 
      it { should  have_hidden_input('bucket').with_value(form_definition.bucket) } 

    end
  end

  RSpec::Matchers.define :have_hidden_input do |name|

    chain :with_value do |value|
      @value = value
    end

    match do |x|
      selector = "input[type=hidden][name='#{name}']"
      selector += "[value='#{@value}']" if @value
      x.should have_css(selector)
    end
  end

end