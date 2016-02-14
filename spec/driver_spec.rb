require 'spec_helper'

module FormulitaBackend
  describe Driver do
    describe '#formatted_name' do
      let(:driver) do
        Driver.new('Fernando', 'Alonso', 'Spanish', 'McLaren', 11)
      end

      it 'returns the name of the Driver formatted' do
        expect(driver.formatted_name).to eq 'F.Alonso'
      end
    end
  end
end
