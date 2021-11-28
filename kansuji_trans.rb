require 'parslet' 
require_relative 'cjk_nodes'
module KansujiToNumber
    class KansujiTrans < Parslet::Transform
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
        rule(wide_int: simple(:x)) { x.to_s.tr("０-９", "0-9").to_i }
        rule(lit_10: simple(:x)) { 10 }
        rule(lit_100: simple(:x)) { 100 }
        rule(lit_1000: simple(:x)) { 1000 }
        rule(lit_10000: simple(:x)) { 10000 }
        rule(lit_100000000: simple(:x)) { 100000000 }
        rule(lit_1000000000000: simple(:x)) { 1000000000000 }
    
        rule(pure_number: simple(:x)) { x }
        rule(layer_1_unit: simple(:x)) { x }
        rule(layer_2_unit: simple(:x)) { x }
    
        rule(pure_expression: sequence(:args)) {
            PureExpressionNode.new(args)
        }
    
        rule(layer_1_expression: subtree(:tree)) {
            Layer1ExpressionNode.new(tree[:left],tree[:unit],tree[:right])
        }
    
        rule(layer_2_expression: subtree(:tree)) {
            Layer2ExpressionNode.new(tree[:left],tree[:unit],tree[:right])
        }
    end
end
