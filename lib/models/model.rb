class Model < SQLObject
  my_attr_accessor

  def initialize(params = {})
    params ||= {}
    super(params)
  end

  def errors
    @errors ||= []
  end

  def valid?
  end

  finalize!
end
