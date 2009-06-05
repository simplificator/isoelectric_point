# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'isoelectric_point'
require 'shoulda'

class IsoelectricTest < Test::Unit::TestCase
  context "When using the isoelectric_point class" do
    setup {@isp_factory = Isoelectric_point.new("dtaselect","PGAKAAAKKPKKAAG")}

    should "Return an error if no sequence is given" do
      assert_raise Exception do Isoelectric_point.new("emboss","")end
    end
    
    should "Count the number of given residues" do
      assert_equal 2, @isp_factory.count_residue("KK", "K")
    end

    should "Count the number of charged groups in the protein" do
      assert_equal 5, @isp_factory.count_charged_residues
    end

    context "charge ratio" do
        should "return partial charge given a ph,pk and state which can be pos(+) or neg(-)" do
          assert_equal 0.5, @isp_factory.charge_ratio(7.0,7.0,"pos")
        end
    end

#     should "Calculate charge of a sequence at a given ph"do
#       assert_in_delta 0.9090, @isp_factory.calculate_charge_at(7.0)
#     end
     should "calculates the isolectric point when given a round off value" do
       assert_equal 10.6089, @isp_factory.calculate_isoelectric_point(10)
     end
  end
end