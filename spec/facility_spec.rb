require 'spec_helper'

RSpec.describe Facility do
  before(:each) do
    @facility = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
  end
  describe '#initialize' do
    it 'can initialize' do
      expect(@facility).to be_an_instance_of(Facility)
      expect(@facility.name).to eq('Albany DMV Office')
      expect(@facility.address).to eq('2242 Santiam Hwy SE Albany OR 97321')
      expect(@facility.phone).to eq('541-967-2014')
      expect(@facility.services).to eq([])
    end
  end

  describe '#add service' do
    it 'can add available services' do
      expect(@facility.services).to eq([])
      @facility.add_service('New Drivers License')
      @facility.add_service('Renew Drivers License')
      @facility.add_service('Vehicle Registration')
      expect(@facility.services).to eq(['New Drivers License', 'Renew Drivers License', 'Vehicle Registration'])
    end
  end

  describe 'Iteration 2' do
    it 'it adds service, creates list of registered vehicles, checks collected_fees is zero' do
      facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
      
      expect(facility_1.add_service('Vehicle Registration')).to eq(["Vehicle Registration"])
      expect(facility_1.registered_vehicles).to eq([])
      expect(facility_1.collected_fees).to eq(0)
    end

    it 'registered vechile is put in list' do
      facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
      cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice})
      
      facility_1.add_service('Vehicle Registration')
      facility_1.register_vehicle(cruz)

      expect(facility_1.registered_vehicles).to eq([cruz])
    end

    it 'adds registered vechicles to list, checks collected_fees' do
      facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
      cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice})
      bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev})
      camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice})

      facility_1.add_service('Vehicle Registration')
      facility_1.register_vehicle(cruz)

      expect(facility_1.registered_vehicles).to eq([cruz])
      expect(facility_1.collected_fees).to eq(100)

      facility_1.register_vehicle(camaro)
      facility_1.register_vehicle(bolt)

      expect(facility_1.registered_vehicles).to eq([cruz, camaro, bolt])
      expect(facility_1.collected_fees).to eq(325)
    end

    it 'checks to see facility 2 has no vehicles, services, cannot add them if service is not available' do
      facility_2 = Facility.new({name: 'Ashland DMV Office', address: '600 Tolman Creek Rd Ashland OR 97520', phone: '541-776-6092' })

      bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev})
      
      expect(facility_2.registered_vehicles).to eq([])
      expect(facility_2.services).to eq([])

      facility_2.register_vehicle(bolt)

      expect(facility_2.registered_vehicles).to eq([])
      expect(facility_2.collected_fees).to eq(0)
    end
  end

  describe "Iteration 2, DL written test" do
    it "administers written test if facility has service" do
      registrant_1 = Registrant.new('Bruce', 18, true )
      facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
      
      expect(facility_1.administer_written_test(registrant_1)).to eq(false)
      
      facility_1.add_service('Written Test')
      
      expect(facility_1.services).to eq(["Written Test"])
      expect(facility_1.administer_written_test(registrant_1)).to eq(true)
    end

    it "it checks other registrants to see if it can administer written test" do
      registrant_2 = Registrant.new('Penny', 16 )
      registrant_3 = Registrant.new('Tucker', 15 )
      facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
      facility_1.add_service('Written Test')
      
      expect(facility_1.administer_written_test(registrant_2)).to eq(false)
      registrant_2.earn_permit
      expect(facility_1.administer_written_test(registrant_2)).to eq(true)
      
      expect(facility_1.administer_written_test(registrant_3)).to eq(false)
      registrant_3.earn_permit
      expect(facility_1.administer_written_test(registrant_3)).to eq(false)
    end
  end
  
  describe "Iteration 2, DL road_test" do
    it "sees if it can administer road test" do
      registrant_1 = Registrant.new('Bruce', 18, true )
      registrant_2 = Registrant.new('Penny', 16 )
      registrant_3 = Registrant.new('Tucker', 15 )
      facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
      facility_1.add_service('Written Test')

      expect(facility_1.administer_road_test(registrant_3)).to eq(false)
      registrant_3.earn_permit
      expect(facility_1.administer_road_test(registrant_3)).to eq(false)

      expect(facility_1.administer_road_test(registrant_1)).to eq(false)
      expect(facility_1.add_service('Road Test')).to eq(["Written Test", "Road Test"])
      expect(facility_1.administer_road_test(registrant_1)).to eq(true)

      registrant_2.earn_permit
      expect(facility_1.administer_road_test(registrant_2)).to eq(true)
    end
  end
  
  describe "Iteration 2, Dl renewal" do
    it "it checks renewal" do
      registrant_1 = Registrant.new('Bruce', 18, true )
      registrant_2 = Registrant.new('Penny', 16 )
      registrant_3 = Registrant.new('Tucker', 15 )
      facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
      facility_1.add_service('Written Test')

      expect(facility_1.renew_drivers_license(registrant_1)).to eq(false)

      facility_1.add_service('Road Test')

      expect(facility_1.add_service('Renew License')).to eq(["Written Test", "Road Test", "Renew License"])
      expect(facility_1.renew_drivers_license(registrant_1)).to eq(true)
      expect(facility_1.renew_drivers_license(registrant_3)).to eq(false)

      registrant_2.earn_permit
      expect(facility_1.renew_drivers_license(registrant_2)).to eq(true)
    end
  end
end
































