require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'byebug'
require_relative './session'
require_relative './flash'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req, @res = req, res
    @already_built_response = false
    @params = req.params.merge(route_params)
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    raise "double render error" if @already_built_response
    @res.status = 302
    @res['Location'] = url
    @already_built_response = true
    session.store_session(@res)
    flash.store_flash(@res)
    nil
  end

  def render_content(content, content_type)
    raise "double render error" if @already_built_response
    @res.write(content)
    @res['Content-Type'] = content_type
    @already_built_response = true
    session.store_session(@res)
    flash.store_flash(@res)
    nil
  end

  def render(template_name)
    dir = self.class.to_s.underscore
    file = "#{template_name.to_s}.html.erb"
    path ="views/#{dir}/#{file}"

    content = ERB.new(File.read(path)).result(binding)
    render_content(content, "text/html")
  end

  def session
    @session ||= Session.new(@req)
  end

  def invoke_action(name)
    self.send(name)
    render(name) unless @already_built_response
  end

  def flash
    if @flash
      puts @flash.info
      puts @flash.info.keys.first.class
      puts @flash.future
    else
      puts "no flash"
    end
    @flash ||= Flash.new(@req)
  end
end
