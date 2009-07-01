require 'extensions'

#calculates the isolectric point of a given protein sequence
class Isoelectric_point

    def initialize(pka_set,sequence)
      #array of basic residues
      @basic_residues = %w{R H K}

      #array of acidic residues
      @acidic_residues = %w{D E}

        #array of charged groups
      @charged_groups = %w{K R H D E C Y}

      #hash of residues at DTA_select pk values
      dta_select_pks = {"N_terminus" => 8.0,
                     "K" => 10.0,
                     "R" => 12.0,
                     "H" => 6.5,
                     "C_terminus" => 3.1,
                     "D" => 4.4,
                     "E" => 4.4,
                     "C" => 8.5,
                     "Y" => 10.0
                     }
      emboss_pks = {"N_terminus" => 8.6,
                     "K" => 10.8,
                     "R" => 12.5,
                     "H" => 6.5,
                     "C_terminus" => 3.6,
                     "D" => 3.9,
                     "E" => 4.1,
                     "C" => 8.5,
                     "Y" => 10.1
                     }
       rodwell_pks = {"N_terminus" => 8.0,
                         "K" => 11.5,
                         "R" => 11.5,
                         "H" => 6.0,
                         "C_terminus" => 3.1,
                         "D" => 3.68,
                         "E" => 4.25,
                         "C" => 8.33,
                         "Y" => 10.07
                         }
       wikipedia_pks = {"N_terminus" => 8.2,
                     "K" => 10.54,
                     "R" => 12.48,
                     "H" => 6.04,
                     "C_terminus" => 3.65,
                     "D" => 3.9,
                     "E" => 4.07,
                     "C" => 8.18,
                     "Y" => 10.47
                     }
      sillero_pks = {"N_terminus" => 8.2,
                     "K" => 10.4,
                     "R" => 12.0,
                     "H" => 6.4,
                     "C_terminus" => 3.2,
                     "D" => 4.0,
                     "E" => 4.5,
                     "C" => 9.0,
                     "Y" => 10.0
                     }
       #TODO add the patrikios pka values,
#       patrikios_pks ={"N_terminus" => ,
#                     "K" => ,
#                     "R" => ,
#                     "H" => ,
#                     "C_terminus" => ,
#                     "D" => ,
#                     "E" => ,
#                     "C" => ,
#                     "Y" => 
#                     }
       #TODO Add a method to allow a user to define their own hash of pka values

        @pka_set = pka_set
        
        case
            when
                @pka_set =~/^emboss$/i
                @pka_set = emboss_pks
            when
                @pka_set=~/^dtaselect$/i
                @pka_set = dta_select_pks
            when
                @pka_set =~/^rodwell$/i
                @pka_set = rodwell_pks
           when
                @pka_set =~/^wikipedia$/i
                @pka_set = wikipedia_pks
           when
                @pka_set =~/^sillero$/i
                @pka_set = sillero_pks
           else
              raise "Pka not defined"
        end #case

        if sequence == " "
          raise "Provide sequence"
        else
         @sequence = sequence
        end
    end #initiliaze

      #Counts number of charged groups in the protein
      def count_charged_residues
        totals =[]
         @charged_groups.each do |i|
             t = count_residue(@sequence,i)
            totals<<t
         end
       count = totals.inject(0) {|x,n| x+n }
       return count
      end

      #calculates the isolectric point
      def calculate_isoelectric_point(roundoff_value)
        ph = 7.0 #initialize the ph value to 7
        step = 3.5 #step upwards or downwards by this value
    #    limit_charge = 0

        #calculate the protein charge at pH 7.
          begin
                charge = calculate_charge_at(ph)

          # propose a new ph half of 7.0 higher or lower than 7.0 depending onthe charge
                # return ph if charge == 0
                 if charge > 0
                      ph += step
                      step /= 2
    #                  puts ph
                #      charge = calculate_charge_at(ph)
                      charge = charge.roundf(roundoff_value)
                 else
                   ph -= step
                      step /= 2
    #                  puts ph
                      charge = calculate_charge_at(ph)
                      charge = charge.roundf(roundoff_value)
                 end
          end while charge == 0
          #if ((pH-pHprev<E)&&(pHnext-pH<E)) //terminal condition, finding isoelectric point with given precision
              #break;
       return ph
      end

      def calculate_charge_at(ph)
        sequence = @sequence.split
        frequencies_hash = amino_frequency_hash(sequence)
        y_count = frequencies_hash["Y"]
        c_count = frequencies_hash["C"]
        e_count = frequencies_hash["E"]
        d_count = frequencies_hash["D"]
        h_count = frequencies_hash["H"]
        r_count = frequencies_hash["R"]
        k_count = frequencies_hash["K"]

        total_protein_charge = charge_ratio(@pka_set["N_terminus"],ph,"pos")
                               + k_count*charge_ratio(@pka_set["K"],ph,"pos")
                               + r_count*charge_ratio(@pka_set["R"],ph,"pos")
                               + h_count*charge_ratio(@pka_set["H"],ph,"pos")
                               - d_count*charge_ratio(@pka_set["D"],ph,"neg")
                               - charge_ratio(@pka_set["C_terminus"],ph,"neg")
                               - e_count*charge_ratio(@pka_set["E"],ph,"neg")
                               - c_count*charge_ratio(@pka_set["C"],ph,"neg")
                               - y_count*charge_ratio(@pka_set["Y"],ph,"neg")
          return total_protein_charge
      end

      #generates a frequency hash of the count of amino acids from an array of residues
    def amino_frequency_hash(amino_acid_to_count)
      amino_acid_to_count.count
    end

    #  returns partial charge given a ph,pk and a state which can be pos(+) or neg(-)
    def charge_ratio(pk,ph,state)
      if state =~ /^pos$/i
         exponent = pk.to_f - ph.to_f
      elsif state=~ /^neg$/i
        exponent = ph.to_f - pk.to_f
      else
        raise ArgumentError("Argument is invalid")
      end
      concentration_ratio = 10**exponent
      partial_charge = concentration_ratio/(concentration_ratio + 1)
      return partial_charge
    end

    #count a given residue in a given sequence
    def count_residue(sequence,residue)
      sequence.count(residue)
    end

end #isoelectric_point 

#examples
#a = Isoelectric_point.new("dtaselect","KK")
#
# c = a.calculate_charge_at(14)
#
##7 is a round off number to improve precision
#myph = a.calculate_isoelectric_point(7)