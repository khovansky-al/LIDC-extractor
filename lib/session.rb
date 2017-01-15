class Session
 
 attr_reader :id
 attr_accessor :nodules
 
  def initialize(id)
    @id = id
    @nodules = []
  end
end