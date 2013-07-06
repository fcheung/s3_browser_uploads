module S3BrowserUploads
  module ViewHelpers
    def s3_form form_definition, html_options={}, &block
      options = {'action' => form_definition.endpoint, 'method' => 'POST', 'enctype' => "multipart/form-data",'accept-charset' => "UTF-8"}
      options.merge! html_options

      output = ActiveSupport::SafeBuffer.new
      output.safe_concat(tag(:form, options, true).html_safe)
      output << hidden_field_tag( 'x-ignore-utf8', '&#x2713;'.html_safe)
      output << capture(&block)
      output.safe_concat("</form>")
    end
    ::ActionView::Base.send :include, self

  end
end