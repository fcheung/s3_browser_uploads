# S3BrowserUploads

Easy straight-to-s3 uploads from your browser for rails. Takes care of policy documents and all that jazz. More details [http://www.spacevatican.org/2013/7/7/direct-to-s3-browser-uploads](here)

## Installation

Add

    gem 's3_browser_uploads'

to your gemfile

## Example Usage

In your controller

    @form_definition = S3BrowserUploads::FormDefinition.new :aws_access_key_id => 'Somekey'
    @form_definition.add_field('x-amz-server-side-encryption', 'AES256')
    @form_definition.add_field('key', 'users/fred/${filename}')
    @form_definition.add_condition('key', 'starts-with' => 'users/fred/')

In your view

    <%= s3_form @form_definition do %> 

      <%= file_field_tag :file %>
      <%= submit_tag 'Upload' %>
    <% end %>


## Details

Every field in your form must be signed as part of the policy document in order for S3 to accept the upload.

Call `add_field` to add a hidden field both to the form and to the policy document. If you want to add the field yourself then call `add_condition` to add the field to the policy document. For example if you wanted to allow the user to choose the acl for the file then you would do

    @form_definition.add_condition 'acl', 'starts-with' => ''

This adds `acl` to the policy document and states that it can take any value. Then you'd need to add an input to the form that would allow the user to choose the acl.
 

You can restrict the allowable size of the upload to 1MB with

    @form_definition.restrict_content_length 0..1024*1024