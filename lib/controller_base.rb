require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
    @already_built_response = false
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response == true
  end

  # Set the response status code and header
  def redirect_to(url)
    if already_built_response?
      raise "Error - Double Response"
    else
      @res.set_header("Location", url)
      @res.status = 302
      @already_built_response = true
    end
  end

  # Populate the response with content.
  # Set the response's content type to the given type.d
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    if already_built_response?
      raise "Error - Double Response"
    else
      @res.body = [content]
      @res['Content-Type'] = content_type
      @already_built_response = true
    end
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    if already_built_response?
      raise "Error - Double Response"
    else
      controller_name = ActiveSupport::Inflector.underscore(self.class.to_s)
      file_path = "views/#{controller_name}/#{template_name}.html.erb"
      file_content = File.read(file_path)
      template_content = ERB.new(file_content).result(binding)
      render_content(template_content, 'text/html')
    end
  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end
