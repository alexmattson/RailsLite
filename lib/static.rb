require 'rack'

class Static
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    public_asset?(req) ? get_asset(req) : app.call(env)
  end

  def public_asset?(req)
    req.path.include?("/public")
  end

  def get_asset(req)

    path = full_path(req)
    ext = ".#{path.split(".").last}"
    res = Rack::Response.new
    res['Content-type'] = MIME_TYPE[ext]
    if File.exists?(path)
      res.write(File.read(path))
    else
      res.status = 404
    end
    res.finish
  end



  def full_path(req)
    dir_path = File.dirname(__FILE__)
    dir_path.slice!("/lib")
    root_path = req.path
    full_path = if root_path.include?(dir_path)
      "#{root_path}"
    else
      "#{dir_path}#{root_path}"
    end
  end

  MIME_TYPE = {".au" => "audio/basic",
  ".avi" => "video/msvideo, video/avi, video/x-msvideo",
  ".bmp" => "image/bmp",
  ".bz2" => "application/x-bzip2",
  ".css" => "text/css",
  ".dtd" => "application/xml-dtd",
  ".doc" => "application/msword",
  ".docx" => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
  ".dotx" => "application/vnd.openxmlformats-officedocument.wordprocessingml.template",
  ".es" => "application/ecmascript",
  ".exe" => "application/octet-stream",
  ".gif" => "image/gif",
  ".gz" => "application/x-gzip",
  ".hqx" => "application/mac-binhex40",
  ".html" => "text/html",
  ".jar" => "application/java-archive",
  ".jpg" => "image/jpeg",
  ".js" => "application/x-javascript",
  ".midi" => "audio/x-midi",
  ".mp3" => "audio/mpeg",
  ".mpeg" => "video/mpeg",
  ".ogg" => "audio/vorbis, application/ogg",
  ".pdf" => "application/pdf",
  ".pl" => "application/x-perl",
  ".png" => "image/png",
  ".potx" => "application/vnd.openxmlformats-officedocument.presentationml.template",
  ".ppsx" => "application/vnd.openxmlformats-officedocument.presentationml.slideshow",
  ".ppt" => "application/vnd.ms-powerpointtd>",
  ".pptx" => "application/vnd.openxmlformats-officedocument.presentationml.presentation",
  ".ps" => "application/postscript",
  ".qt" => "video/quicktime",
  ".ra" => "audio/x-pn-realaudio",
  ".ram" => "audio/x-pn-realaudio",
  ".rdf" => "application/rdf",
  ".rtf" => "application/rtf",
  ".sgml" => "text/sgml",
  ".sit" => "application/x-stuffit",
  ".sldx" => "application/vnd.openxmlformats-officedocument.presentationml.slide",
  ".svg" => "image/svg+xml",
  ".swf" => "application/x-shockwave-flash",
  ".tar.gz" => "application/x-tar",
  ".tgz" => "application/x-tar",
  ".tiff" => "image/tiff",
  ".tsv" => "text/tab-separated-values",
  ".txt" => "text/plain",
  ".wav" => "audio/wav, audio/x-wav",
  ".xlam" => "application/vnd.ms-excel.addin.macroEnabled.12",
  ".xls" => "application/vnd.ms-excel",
  ".xlsb" => "application/vnd.ms-excel.sheet.binary.macroEnabled.12",
  ".xlsx" => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
  ".xltx" => "application/vnd.openxmlformats-officedocument.spreadsheetml.template",
  ".xml" => "application/xml",
  ".zip" => "application/zip"}

end
