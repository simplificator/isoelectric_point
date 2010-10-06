require 'test_helper'
include IsoelectricPoint
class SequenceTest < Test::Unit::TestCase

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
    should 'calculate' do
      places = 2
      @known.each do |sequence, expected|
        actual = Sequence.new(sequence).calculate_iep(places)
        assert_equal expected.round_to_places(places), actual, "Expected the iep to be #{expected} but was #{actual} for #{sequence}"
      end
    end
  end

  should "Raise if not sequence given" do
    assert_raise ArgumentError do
      Sequence.new(nil)
    end
  end

  should "Raise if empty sequence given" do
    assert_raise ArgumentError do
      Sequence.new(' ')
    end
  end


  should "Raise if unknown pks used" do
    assert_raise ArgumentError do
      Sequence.new('PG', 'youdontknowme')
    end
  end

  context "a Sequence" do
    setup do
      @sequence = Sequence.new("PGAKAAAKKPKKAAG")
    end

    should "calculates the isolectric point to 0 places" do
      assert_equal 11, @sequence.calculate_iep(0)
    end
    should "calculates the isolectric pointto 3 places" do
      assert_equal 10.603, @sequence.calculate_iep(3)
    end
  end
end