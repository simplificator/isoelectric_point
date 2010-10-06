require 'test_helper'
include IsoelectricPoint
class SequenceTest < Test::Unit::TestCase

  context 'some known sequences' do
    setup do
      @known = {
        'D' => 3.81
      }
    end
    should 'calculate' do
      #fail "This does not work...., loops forever. or at least very long"
      @known.each do |sequence, ph|
        assert_equal ph, Sequence.new(sequence).calculate_iep(2)
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