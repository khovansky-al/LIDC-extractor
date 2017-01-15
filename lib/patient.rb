class Patient
  
  attr_reader :id, :xml

  def initialize(id, xml)
    @id, @xml = id, xml
  end
end