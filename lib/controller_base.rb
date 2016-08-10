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
    check_authenticity_token if protected_class?
    self.send(name)
    render(name) unless @already_built_response
  end

  def flash
    @flash ||= Flash.new(@req)
  end


  #Authenticity checks

  def self.protect_from_forgery
    @@protected = true
  end

  def protected_class?
    @@protected && !(req.request_method == "GET")
  end

  def form_authenticity_token
    token = generate_auth_token
    set_auth_cookie(token)
    token
  end

  def generate_auth_token
    @auth_token ||= SecureRandom::urlsafe_base64(32)
  end

  def set_auth_cookie(token)
    token = token.to_json.delete('\"')
    cookie = { path: '/', value: token}
    res.set_cookie("authenticity_token", cookie)
  end

  def get_auth_cookie
    cookie = Regexp.new("authenticity_token=([^\;]+)").match(req.env['HTTP_COOKIE'])
    cookie ? cookie[1] : nil
  end

  def check_authenticity_token
    unless get_auth_cookie && self.params["authenticity_token"] == get_auth_cookie
      raise AuthenticityTokenError
    end
  end
end

class AuthenticityTokenError < StandardError
  def initialize(msg="Invalid authenticity token")
    super
  end
end
