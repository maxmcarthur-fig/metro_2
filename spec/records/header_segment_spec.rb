require 'spec_helper'

describe Metro2::Records::HeaderSegment do
  before(:each) do
    @header = Metro2::Records::HeaderSegment.new
    @header.cycle_number = 15
    @header.equifax_program_identifier = 'EFAXID'
    @header.transunion_program_identifier = 'TRANSUNION'
    @header.activity_date = Date.new(2014,9,14)
    @header.created_date = Date.new(2014,9,15)
    @header.program_date = Date.new(2014,9,1)
    @header.program_revision_date = '01'
    @header.reporter_name = 'Credit Reporter'
    @header.reporter_address = '123 Report Dr Address CA 91111'
    @header.reporter_telephone_number = '5555555555'
    @header.software_vendor_name = 'metro 2 gem'
    @header.software_version_number = '2'
  end

  describe '#to_metro2' do
    it 'should generate header segment string' do
      exp = [
        '0426',
        'HEADER',
        '15',
        '          ',
        'EFAXID    ',
        '     ',
        'TRANSUNION',
        '09142014',
        '09152014',
        '09012014',
        '00000001',
        'Credit Reporter'.ljust(40, ' '),
        '123 Report Dr Address CA 91111'.ljust(96, ' '),
        '5555555555',
        'metro 2 gem'.ljust(40, ' '),
        '2    ',
        ' ' * 156
      ]
      expect(@header.to_metro2).to eql(exp.join(''))
    end
  end
end
