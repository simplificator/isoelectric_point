#calculates the isoelectric point of a given protein sequence
module IsoelectricPoint
  class Sequence
    CHARGED_GROUPS = %w{K R H D E C Y}
    KEYS_PLUS = ['K', 'R', 'H']
    KEYS_MINUS = ['D', 'E', 'C', 'Y']

    attr_accessor :value
    attr_reader :pks

    def initialize(sequence, pka_set_name = 'dtaselect')
      raise ArgumentError.new("pka_set_name is required") if pka_set_name.nil? || pka_set_name.strip == ''
      raise ArgumentError.new("sequence is required") if sequence.nil? || sequence.strip == ''
      @pks = Data::PKAS[pka_set_name]
      @value = sequence.upcase.gsub(/\s/, '')
      raise ArgumentError.new("pka_set '#{pka_set_name}' is unknown. Please specify one of #{Data::PKAS.keys.join(', ')}") unless self.pks
    end

    def calculate_iep(places = 2)
      precission = 5
      ph = 7.5
      step = 3.5
      target_charge = 0.0
      begin
        current_charge = calculate_charge_at(ph)
        if current_charge > 0
          ph += step
        else
          ph -= step
        end
        step /= 2.0
        puts "#{self.value}: %.10f / #{step} / #{ph}" % current_charge
        #sleep 0.1

      end while current_charge == nil || target_charge.round_to_places(precission) != current_charge.round_to_places(precission)
      ph.round_to_places(places)
    end


    def calculate_charge_at(ph)
      charge = partial_charge(pks['N_TERMINUS'], ph) +
      KEYS_PLUS.inject(0) do |memo, item|
        memo += partial_charge(self.pks[item], ph) * charged_residue_frequencies[item]
      end -
      KEYS_MINUS.inject(0) do |memo, item|
        memo += partial_charge(ph, self.pks[item]) * charged_residue_frequencies[item]
      end -
      partial_charge(ph, pks['C_TERMINUS'])

      charge
    end

    private

    def charged_residue_frequencies
      @charged_residue_frequency ||= calculate_charged_residue_frequencies
    end

    def partial_charge(a, b)
      x = 10 ** (a - b)
      x / (x + 1).to_f
    end

    def calculate_charged_residue_frequencies
      CHARGED_GROUPS.inject(Hash.new(0)) do |memo, item|
        memo[item] = self.value.count(item)
        memo
      end
    end

  end
end