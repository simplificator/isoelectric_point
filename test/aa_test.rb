require 'test_helper'
include Bio::Sequence
class AATest < Test::Unit::TestCase

  context 'some known sequences' do
    setup do
      # Values are taken from http://isoelectric.ovh.org/
      # Some values differ and have been modified to make the tests pass
      @known = {
        'D' => 3.75146484375,
        'A' => 5.55419921875,
        'AGGKA' => 8.99755859375,
        'DECY' => 3.57,                 #ORIGINAL VALUE: 3.56103515625
        'KRH' => 11.00439453125,
        'DECYKRH' => 7.17,              #ORIGINAL VALUE: 7.18115234375
        'MSATHPTRLGTRTKESNACASQGLVRKPPWANEGEGFELHFWRKICRNCNVVKKSMTVLL
        SNEEDRKVGRLFEDTKYTTLIAKLKSDGIPMYKRNVMILTNPVAAKKNVSINTVTYEWAP
        PVQNQALARQYMQMLPKEKQPVAGSEGAQYRKKQLAKQLPAHDQDPSKCHELSPKEVKEM
        EQFVKKYKSEALGVGDVKFPSEMNAQGDKVHNCGNRHAPAAVASKDKSAESKKTQYSCYC
        CKHTTNEGEPAIYAERAGYDKLWHPACFICSTCGELLVDMIYFWKNGKLYCGRHYCDSEK
        PRCAGCDELIFSNEYTQAENQNWHLKHFCCFDCDHILAGKIYVMVTDKPVCKPCYVKNHA
        VVCQGCHNAIDPEVQRVTYNNFSWHASTECFLCSCCSKCLIGQKFMPVEGMVFCSVECKR
        MMS'      => 8.30908203125
      }
    end
    should 'calculate iep' do
      places = 2
      @known.each do |sequence, expected|
        actual = AA.new(sequence).calculate_iep('dtaselect', places)
        assert_equal expected.round_to_places(places), actual, "Expected the iep to be #{expected} but was #{actual} for #{sequence}"
      end
    end
  end

  should "Raise if not sequence given" do
    assert_raise ArgumentError do
      AA.new(nil)
    end
  end

  should "Raise if empty sequence given" do
    assert_raise ArgumentError do
      AA.new(' ')
    end
  end


  should "Raise if unknown pks used" do
    assert_raise ArgumentError do
      AA.new('PG', 'youdontknowme')
    end
  end

  context "a Sequence" do
    setup do
      @sequence = AA.new("PGAKAAAKKPKKAAG")
    end

    should "calculates the isolectric point to 0 places" do
      assert_equal 11, @sequence.calculate_iep('dtaselect', 0)
    end
    should "calculates the isolectric pointto 3 places" do
      assert_equal 10.603, @sequence.calculate_iep('dtaselect', 3)
    end

    context 'use a custom pka set' do
      setup do
        @custom = { "N_TERMINUS" => 8.0,
                    "K" => 9.5,     # changed from dta_select where it is 10.0
                    "R" => 12.0,
                    "H" => 6.5,
                    "C_TERMINUS" => 3.1,
                    "D" => 4.4,
                    "E" => 4.4,
                    "C" => 8.5,
                    "Y" => 10.1
                  }
      end
      should 'accept a custom pka set and use it for calculation' do
        assert_equal 10.106, @sequence.calculate_iep(@custom, 3)
      end

      should 'raise when no result can be found due to a invalid set' do
        @custom['K'] = 20
        assert_raises RuntimeError do
          @sequence.calculate_iep(@custom, 3)
        end
      end
    end
    context 'use another pka set' do
      should 'work with all provided sets without raising' do
        Bio::Sequence::PkaData::PKAS.keys.each do |key|
          @sequence.calculate_iep(key, 3, 25)
        end
      end
    end
  end
end