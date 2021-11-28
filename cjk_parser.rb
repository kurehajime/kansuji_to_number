require 'parslet' 
module KansujiToNumber
    class CjkParser < Parslet::Parser

        # non number
        rule(:space)      { match('\s').repeat(1) }
        rule(:space?)     { space.maybe }
    
        # pure number
        rule(:int)    { match('[0-9]').as(:int) >> space? }
        rule(:wide_int)    { match('[１２３４５６７８９０]').as(:wide_int) >> space? }
        rule(:lit_0)     { (str('零') | str('〇') ).as(:lit_0) >> space? }
        rule(:lit_1)     { str('一').as(:lit_1) >> space? }
        rule(:lit_2)     { str('二').as(:lit_2) >> space? }
        rule(:lit_3)     { str('三').as(:lit_3) >> space? }
        rule(:lit_4)     { str('四').as(:lit_4) >> space? }
        rule(:lit_5)     { str('五').as(:lit_5) >> space? }
        rule(:lit_6)     { str('六').as(:lit_6) >> space? }
        rule(:lit_7)     { str('七').as(:lit_7) >> space? }
        rule(:lit_8)     { str('八').as(:lit_8) >> space? }
        rule(:lit_9)     { str('九').as(:lit_9) >> space? }
    
        # layer 1 unit
        rule(:lit_10)     { (str('十')).as(:lit_10) >> space? }
        rule(:lit_100)    { (str('百')).as(:lit_100) >> space? }
        rule(:lit_1000)   { (str('千')).as(:lit_1000) >> space? }
    
        # layer 2 unit
        rule(:lit_10000)        { (str('万')).as(:lit_10000) >> space? }
        rule(:lit_100000000)    { (str('億')).as(:lit_100000000) >> space? }
        rule(:lit_1000000000000){ (str('兆')).as(:lit_1000000000000) >> space? }
    
        # group
        rule(:pure_number){(
            lit_0|
            lit_1|
            lit_2|
            lit_3|
            lit_4|
            lit_5|
            lit_6|
            lit_7|
            lit_8|
            lit_9|
            int|
            wide_int).as(:pure_number) }
        
        rule(:layer_1_unit){(
            lit_10|
            lit_100|
            lit_1000).as(:layer_1_unit) }
    
        rule(:layer_2_unit){(
            lit_10000|
            lit_100000000|
            lit_1000000000000).as(:layer_2_unit) }
    
        # expression
        rule(:pure_expression){pure_number.repeat(1).as(:pure_expression) }
    
        rule(:layer_1_expression){ 
            (pure_expression.maybe.as(:left) >> layer_1_unit.as(:unit) >> layer_1_expression.maybe.as(:right)).as(:layer_1_expression) |
            pure_expression
         }
    
        rule(:layer_2_expression){ 
            (layer_1_expression.as(:left) >> layer_2_unit.as(:unit) >> layer_2_expression.maybe.as(:right)).as(:layer_2_expression) |
            layer_1_expression
        }
    
        # root
        root :layer_2_expression
    end
end