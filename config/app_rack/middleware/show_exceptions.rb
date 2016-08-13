require 'erb'
require 'byebug'

class ShowExceptions
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    app.call(env)
  rescue Exception => e
    render_exception(e)
  end

  private

  def render_exception(e)
    dir_path = File.dirname(__FILE__).gsub("/config/app_rack/middleware", "")
    path = "#{dir_path}/rails/templates/rescue.html.erb"
    template = File.read(path)
    source = render_source(e)

    final = ERB.new(template).result(binding)

    ['500', {'Content-type' => 'text/html'}, [final]]
  end

  def render_source(e)
    error = e.backtrace.find{|x| !x.include?("ruby") && !x.include?("erb") }
    # error = e.backtrace.first
    dir_path = File.dirname(__FILE__)
    dir_path.gsub("/lib", "")
    root_path = Regexp.new("([^:]+)").match(error).to_s

    full_path = if root_path.include?(dir_path)
      "#{root_path}"
    else
      "#{dir_path}/#{root_path}"
    end


    line = error.split(":")[1].to_i

    raw_source = File.readlines(full_path)[line - 4 .. line + 3]
    format_source(raw_source)
  end

  def format_source(raw)
    raw.each {|l| l.slice!("\n")}

    final = "<div style='border-style: solid; border-color: red;'>"
    raw.each_with_index do |line, idx|
      if idx == 3
        final += "<pre style='background: yellow; width: 100%; height:10pt;'>#{line}</pre>"
      else
        final += "<pre>#{line}</pre>"
      end
    end
    final + "</div>"
  end

end
