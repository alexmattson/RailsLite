Dir[File.dirname(__FILE__) + "../views/dogs/*.html.erb"].each {|file| require file }
require_relative '../models/dog'

class DogsController < ControllerBase
  protect_from_forgery

  def index
    @dogs = Dog.all
  end

  def show
    @dog = Dog.find(params["id"])
  end

  def new
    @dog = Dog.new
  end

  def create
    @dog = Dog.new(params["dog"])
    if @dog.valid?
      @dog.save
      flash[:notice] = "Saved dog successfully"
      redirect_to "/dogs"
    else
      flash.now[:errors] = @dog.errors
      render :new
    end
  end

  def edit
    @dog = Dog.find(params["id"])
  end

  def update
    @dog = Dog.find(params["id"])
    if @dog.valid?
      @dog.update(params["dog"])
      flash[:notice] = "Saved dog successfully"
      redirect_to "/dogs"
    else
      flash.now[:errors] = @dog.errors
      render :edit
    end
  end

  def destroy
    @dog = Dog.find(params["id"])
    @dog.destroy
    redirect_to "/dogs"
  end

  def critical
    raise "Critical error. Abort, abort, abort"
  end
end
