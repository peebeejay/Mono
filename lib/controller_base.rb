require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, params = {})
    @req = req
    @res = res
    @params = @req.params.merge(params)
    @already_built_response = false
  end

  def already_built_response?
    @already_built_response == true
  end

  def redirect_to(url)
    if already_built_response?
      raise "Error - Double Response"
    else
      @res.set_header("Location", url)
      @res.status = 302
      session.store_session(@res)
      @already_built_response = true
    end
  end

  def render_content(content, content_type)
    if already_built_response?
      raise "Error - Double Response"
    else
      @res.body = [content]
      @res['Content-Type'] = content_type
      session.store_session(@res)
      @already_built_response = true
    end
  end

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

  def session
    @session ||= Session.new(@req)
  end

  def invoke_action(name)
    self.send(name)
  end
end
