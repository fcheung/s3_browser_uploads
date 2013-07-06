require 'spec_helper'

describe S3BrowserUploads::ViewHelpers, :type => 'helper' do
  include Capybara::RSpecMatchers
  include RSpec::Rails::HelperExampleGroup
  let(:form_definition) {S3BrowserUploads::FormDefinition.new(:region => 'eu-west-1', :bucket => 'some-bucket')}

  describe 's3_form' do
    let(:content) {helper.s3_form(form_definition) {}}

    describe 'form tag' do
      subject {Capybara.string(content).find('form')}
      its([:action]) { should == form_definition.endpoint }
      its([:enctype]) { should == 'multipart/form-data' }
      its([:method]) { should == 'POST' }
    end

  end

end