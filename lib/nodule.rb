class Nodule
  
  attr_reader :id, :malignancy, :regions

  def initialize(id, malignancy)
    @id, @malignancy = id, malignancy
    @regions = []
  end
end