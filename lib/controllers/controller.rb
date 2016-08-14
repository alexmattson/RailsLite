Dir[File.dirname(__FILE__) + "../views/MODEL/*.html.erb"].each {|file| require file }
require_relative '../models/MODEL'

# Change model name in boht view and model require paths above
# Fill in model name for controller below

class ModelsController < ControllerBase
  protect_from_forgery

  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
