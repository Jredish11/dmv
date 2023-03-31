class Facility
  attr_reader :name, 
              :address, 
              :phone, 
              :services,
              :registered_vehicles,
              :collected_fees

  def initialize(data)
    @name = data[:name]
    @address = data[:address]
    @phone = data[:phone]
    @services = []
    @registered_vehicles = []
    @collected_fees = 0
  end

  def add_service(service)
    @services << service
  end

  def register_vehicle(vehicle)
    return nil unless services.include?("Vehicle Registration")
    vehicle.registration_date = Date.today
    if vehicle.antique?
      @collected_fees += 25
      vehicle.plate_type = :antique
    elsif vehicle.electric_vehicle?
      @collected_fees += 200
      vehicle.plate_type = :ev
    else
      @collected_fees += 100
      vehicle.plate_type = :regular
    end
    @registered_vehicles << vehicle
  end

  def administer_written_test(registrant)
    return false unless services.include?("Written Test")
    if registrant.permit? && registrant.age >= 16
      registrant.license_data[:written] = true
    else
      false
    end
  end

  def administer_road_test(registrant)
    if administer_written_test(registrant) == true
      registrant.license_data[:license] = true
      true
    else
      false
    end
    #A road test can only be administered to registrants who have passed the written test
  # For simplicity’s sake, Registrants who qualify for the road test automatically earn a license
  end
end


  
