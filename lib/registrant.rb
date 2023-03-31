class Registrant
  attr_reader :name, :age, :permit
  attr_accessor :license_data
  
  def initialize(name, age, permit = false)
    @name = name
    @age = age
    @permit = permit
  end

  def permit?   
    @permit
  end

  def license_data
    {
      :written => false,
      :license => false,
      :renewed => false,
    }
  end

  def earn_permit
   @permit = true
  end
end