require 'minitest/autorun'
require_relative 'cjk_to_num'

class CjkToNumberTest < Minitest::Test

    def test_pure
        parsed = CjkToNumber.parse("1")
        assert_equal parsed, {:pure_expression=>[{:pure_number=>{:int=>"1"}}]}

        parsed = CjkToNumber.parse("一")
        assert_equal parsed, {:pure_expression=>[{:pure_number=>{:lit_1=>"一"}}]}

        parsed = CjkToNumber.parse("零一二三四五六七八九〇")
        assert_equal parsed, {:pure_expression=>
            [{:pure_number=>{:lit_0=>"零"}},
             {:pure_number=>{:lit_1=>"一"}},
             {:pure_number=>{:lit_2=>"二"}},
             {:pure_number=>{:lit_3=>"三"}},
             {:pure_number=>{:lit_4=>"四"}},
             {:pure_number=>{:lit_5=>"五"}},
             {:pure_number=>{:lit_6=>"六"}},
             {:pure_number=>{:lit_7=>"七"}},
             {:pure_number=>{:lit_8=>"八"}},
             {:pure_number=>{:lit_9=>"九"}},
             {:pure_number=>{:lit_0=>"〇"}}]}
    end

    def test_layer1_unit
        parsed = CjkToNumber.parse("千百十")
        assert_equal parsed,  {:layer_1_expression=>
            {:left=>nil,
             :unit=>{:layer_1_unit=>{:lit_1000=>"千"}},
             :right=>
              {:layer_1_expression=>
                {:left=>nil,
                 :unit=>{:layer_1_unit=>{:lit_100=>"百"}},
                 :right=>
                  {:layer_1_expression=>
                    {:left=>nil,
                     :unit=>{:layer_1_unit=>{:lit_10=>"十"}},
                     :right=>nil}}}}}}
    end

    def test_layer2_unit
        parsed = CjkToNumber.parse("一兆二億三万四千五百六十七")
        assert_equal parsed,
         {:layer_2_expression=>
            {:left=>{:pure_expression=>[{:pure_number=>{:lit_1=>"一"}}]},
             :unit=>{:layer_2_unit=>{:lit_1000000000000=>"兆"}},
             :right=>
              {:layer_2_expression=>
                {:left=>{:pure_expression=>[{:pure_number=>{:lit_2=>"二"}}]},
                 :unit=>{:layer_2_unit=>{:lit_100000000=>"億"}},
                 :right=>
                  {:layer_2_expression=>
                    {:left=>{:pure_expression=>[{:pure_number=>{:lit_3=>"三"}}]},
                     :unit=>{:layer_2_unit=>{:lit_10000=>"万"}},
                     :right=>
                      {:layer_1_expression=>
                        {:left=>{:pure_expression=>[{:pure_number=>{:lit_4=>"四"}}]},
                         :unit=>{:layer_1_unit=>{:lit_1000=>"千"}},
                         :right=>
                          {:layer_1_expression=>
                            {:left=>
                              {:pure_expression=>[{:pure_number=>{:lit_5=>"五"}}]},
                             :unit=>{:layer_1_unit=>{:lit_100=>"百"}},
                             :right=>
                              {:layer_1_expression=>
                                {:left=>
                                  {:pure_expression=>[{:pure_number=>{:lit_6=>"六"}}]},
                                 :unit=>{:layer_1_unit=>{:lit_10=>"十"}},
                                 :right=>
                                  {:pure_expression=>
                                    [{:pure_number=>{:lit_7=>"七"}}]}}}}}}}}}}}}}
    end

    def test_trans
        result = CjkToNumber.trans("一兆二億三万四千五百六十七")
        assert_equal result, 1000200034567

        result = CjkToNumber.trans("12兆34億5万6千7百89")
        assert_equal result, 12003400056789

        result = CjkToNumber.trans("一千二百三十四万")
        assert_equal result, 12340000

        assert_raises Parslet::ParseFailed do
            result = CjkToNumber.trans("1億万")
            pp result
        end
    end
end
  