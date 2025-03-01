require 'date'

module Metro2
  class Metro2File
    include Fields

    attr_reader :base_segments
    attr_reader :header
    attr_reader :trailer

    def initialize
      @base_segments = []
      @header = Records::HeaderSegment.new
    end

    def to_s
      segments = []
      segments << @header
      @base_segments.each { |base| segments << base }
      @trailer ||= trailer_from_base_segments
      segments << @trailer

      segments.collect { |r| r.to_metro2 }.join("\n") + "\n"
    end

    def self.parse(file)
      # One header line, plenty of records, then one trailer line.
      line_count = file.length
      new.tap do |record|
        record.instance_variable_set(:@header, Records::HeaderSegment.from_metro2(file[0]))
        record.instance_variable_set(:@base_segments, file[1..line_count - 2].map { |l| Records::BaseSegment.from_metro2(l) })
        record.instance_variable_set(:@trailer, Records::TrailerSegment.from_metro2(file[-1]))
      end
    end

    def trailer_from_base_segments
      status_code_count = Hash.new(0)
      num_ssn = 0
      num_dob = 0
      num_telephone = 0
      num_ecoa_code_z = 0
      total_k2_segments = 0

      @base_segments.each do |base|
        status_code_count[base.account_status.upcase] += 1
        num_ssn += 1 if  base.social_security_number
        num_dob += 1 if base.date_of_birth
        num_telephone += 1 if base.telephone_number
        num_ecoa_code_z += 1 if base.ecoa_code == 'Z'
        total_k2_segments += 1 if base.k2_segment
      end

      trailer = Records::TrailerSegment.new
      trailer.total_base_records = @base_segments.size
      trailer.total_status_code_df = status_code_count['DF']
      trailer.total_status_code_da = status_code_count['DA']
      trailer.total_status_code_05 = status_code_count['05']
      trailer.total_status_code_11 = status_code_count['11']
      trailer.total_status_code_13 = status_code_count['13']
      trailer.total_status_code_61 = status_code_count['61']
      trailer.total_status_code_62 = status_code_count['62']
      trailer.total_status_code_63 = status_code_count['63']
      trailer.total_status_code_64 = status_code_count['64']
      trailer.total_status_code_65 = status_code_count['65']
      trailer.total_status_code_71 = status_code_count['71']
      trailer.total_status_code_78 = status_code_count['78']
      trailer.total_status_code_80 = status_code_count['80']
      trailer.total_status_code_82 = status_code_count['82']
      trailer.total_status_code_83 = status_code_count['83']
      trailer.total_status_code_84 = status_code_count['84']
      trailer.total_status_code_88 = status_code_count['88']
      trailer.total_status_code_89 = status_code_count['89']
      trailer.total_status_code_93 = status_code_count['93']
      trailer.total_status_code_94 = status_code_count['94']
      trailer.total_status_code_94 = status_code_count['95']
      trailer.total_status_code_96 = status_code_count['96']
      trailer.total_status_code_97 = status_code_count['97']
      trailer.ecoa_code_z = num_ecoa_code_z
      trailer.total_social_security_numbers = num_ssn
      trailer.total_social_security_numbers_in_base = num_ssn
      trailer.total_date_of_births = num_dob
      trailer.total_date_of_births_in_base = num_dob
      trailer.total_telephome_numbers = num_telephone
      trailer.total_k2_segments = total_k2_segments
      trailer
    end

  end
end
