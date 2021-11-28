require 'parslet' 

class CjkParser < Parslet::Parser

    # non number
    rule(:space)      { match('\s').repeat(1) }
    rule(:space?)     { space.maybe }

    # pure number
    rule(:int)    { match('[0-9]').as(:int) >> space? }

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

    # none break unit
    rule(:lit_10)     { (str('十')).as(:lit_10) >> space? }
    rule(:lit_100)    { (str('百')).as(:lit_100) >> space? }
    rule(:lit_1000)   { (str('千')).as(:lit_1000) >> space? }

    # break unit
    rule(:lit_10000)        { (str('万')).as(:lit_10000) >> space? }
    rule(:lit_100000000)    { (str('億')).as(:lit_100000000) >> space? }
    rule(:lit_1000000000000){ (str('兆')).as(:lit_1000000000000) >> space? }

    # Things
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
        int).as(:pure_number) }
    
    rule(:layer_1_unit){(
        lit_10|
        lit_100|
        lit_1000).as(:layer_1_unit) }

    rule(:layer_2_unit){(
        lit_10000|
        lit_100000000|
        lit_1000000000000).as(:layer_2_unit) }

    # Expression

    rule(:pure_expression){pure_number.repeat(1).as(:pure_expression) }

    rule(:layer_1_expression){ 
        (pure_expression.maybe.as(:left) >> layer_1_unit.as(:unit) >> layer_1_expression.maybe.as(:right)).as(:layer_1_expression) |
        pure_expression
     }

     rule(:layer_2_expression){ 
        (layer_1_expression.maybe.as(:left) >> layer_2_unit.as(:unit) >> layer_2_expression.maybe.as(:right)).as(:layer_2_expression) |
        layer_1_expression
     }


    # Grammar parts
    root :layer_2_expression
end

PureExpressionNode = Struct.new(:value) do
    def eval
      value.to_i
    end
end

Layer1ExpressionNode = Struct.new(:left, :unit, :right) do
    def eval
        l = left.eval || 1
        r = right.eval || 0
        l * unit + r
    end
end

Layer2ExpressionNode = Struct.new(:left, :unit, :right) do
    def eval
        l = left.eval || 1
        r = right.eval || 0
        l * unit + r
    end
end
 
class CjkTrans < Parslet::Transform
    rule(lit_0: simple(:x)) { 0 }
    rule(lit_1: simple(:x)) { 1 }
    rule(lit_2: simple(:x)) { 2 }
    rule(lit_3: simple(:x)) { 3 }
    rule(lit_4: simple(:x)) { 4 }
    rule(lit_5: simple(:x)) { 5 }
    rule(lit_6: simple(:x)) { 6 }
    rule(lit_7: simple(:x)) { 7 }
    rule(lit_8: simple(:x)) { 8 }
    rule(lit_9: simple(:x)) { 9 }
    rule(int: simple(:x)) { x.to_i }
    rule(lit_10: simple(:x)) { 10 }
    rule(lit_100: simple(:x)) { 100 }
    rule(lit_1000: simple(:x)) { 1000 }
    rule(lit_10000: simple(:x)) { 10000 }
    rule(lit_100000000: simple(:x)) { 100000000 }
    rule(lit_1000000000000: simple(:x)) { 1000000000000 }

    rule(pure_number: simple(:x)) { x }
    rule(layer_1_unit: simple(:x)) { x }
    rule(layer_2_unit: simple(:x)) { x }

    rule(pure_expression: sequence(:x)) {
        sum = 0 
        figure = 1
        x.reverse.inject(0) {|result, item|
         result = result + item * figure
         figure *= 10
         PureExpressionNode.new(result)
        }
    }

    rule(layer_1_expression: subtree(:tree)) {
        Layer1ExpressionNode.new(tree[:left],tree[:unit],tree[:right])
    }

    rule(layer_2_expression: subtree(:tree)) {
        Layer2ExpressionNode.new(tree[:left],tree[:unit],tree[:right])
    }

end

# parsed = CjkParser.new.parse("零一二三四五六七八九〇") 
parsed = CjkParser.new.parse("2万千五百十一") 
pp CjkTrans.new.apply(parsed)