require 'spec_helper'

describe S3BrowserUploads::ViewHelpers, :type => 'helper' do
  include Capybara::RSpecMatchers
  include RSpec::Rails::HelperExampleGroup
  let(:form_definition) {S3BrowserUploads::FormDefinition.new(:region => 'eu-west-1', :bucket => 'some-bucket')}

  describe 's3_form' do
    let(:content) {helper.s3_form(form_definition) {}}
    it 'should render a form tag pointing at the bucket' do
      content.should have_css("form[action='#{form_definition.endpoint}']")
    end

    it 'should rename the utf8 enforcer' do
      content.should_not have_css("input[name=utf8]")
      content.should have_css("input[name='x-ignore-utf8']")
    end
  end

end