require 'parslet' 

class CjkParser < Parslet::Parser

    # non number
    rule(:space)      { match('\s').repeat(1) }
    rule(:space?)     { space.maybe }

    # pure number
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
        lit_9).repeat(1).as(:cjk_num) }

    # Grammar parts
    root :pure_number
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
end

parsed = CjkParser.new.parse("零一二三四五六七八九〇") 
pp CjkTrans.new.apply(parsed)