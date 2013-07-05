module S3BrowserUploads
  module ViewHelpers
    def s3_form form_definition, html_options={}, &block
      form_tag form_definition.endpoint, {:multipart => true, :authenticity_token => false}.merge(html_options) do
        capture(&block)
      end
    end
    ::ActionView::Base.send :include, self

  end
end