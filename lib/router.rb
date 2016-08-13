class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    return false unless !!pattern.match( req.path )
    return false unless !!(http_method == req.request_method.downcase.to_sym)
    true
  end

  def run(req, res)
    params = pattern.match(req.path)
    route_params = Hash.new
    params.names.each_with_index do |key, idx|
      route_params[key] = params[idx + 1]
    end
    controller = controller_class.new(req, res, route_params)
    controller.invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.each do |route|
      return route if route.matches?(req)
    end
    nil
  end

  def run(req, res)
    matching = match(req)

    unless matching
      res.status = 404
      res.write("404")
    else
      matching.run(req, res)
    end
  end
end
