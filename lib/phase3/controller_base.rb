require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content

    # Phase IIIb: reading and evaluating templates

# Let's write a render(template_name) method that will:
#
# Use File.read to read in a template file (in the format views/#{controller_name}/#{template_name}.html.erb).
# Create a new ERB template from the contents.
# Use binding to capture the controller's instance variables.
# Evaluate the ERB template.
# Pass the content to render_content.

    def render(template_name)
      controller_name = self.class.to_s.underscore

      template = File.open("/Users/chris/app-academy/rails-lite/views/#{controller_name}/#{template_name.to_s}.html.erb", 'r')
      template = template.read

      content = ERB.new(template).result(binding)

      render_content(content, 'text/html')

    end
  end
end
