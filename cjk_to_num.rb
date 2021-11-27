require 'parslet' 

class CjkParser < Parslet::Parser

    # non number
    rule(:space)      { match('\s').repeat(1) }
    rule(:space?)     { space.maybe }

    # pure number
    rule(:zero)     { (str('零') | str('〇') ).as(:zero) >> space? }
    rule(:one)     { str('一').as(:one) >> space? }
    rule(:two)     { str('二').as(:two) >> space? }
    rule(:three)     { str('三').as(:three) >> space? }
    rule(:four)     { str('四').as(:four) >> space? }
    rule(:five)     { str('五').as(:five) >> space? }
    rule(:six)     { str('六').as(:six) >> space? }
    rule(:seven)     { str('七').as(:seven) >> space? }
    rule(:eight)     { str('八').as(:eight) >> space? }
    rule(:nine)     { str('九').as(:nine) >> space? }

    # Things
    rule(:pure_number){(
        zero|
        one|
        two|
        three|
        four|
        five|
        six|
        seven|
        eight|
        nine).repeat(1).as(:cjk_num) }

    # Grammar parts
    root :pure_number
end

class CjkTrans < Parslet::Transform
    rule(zero: simple(:x)) { 0 }
    rule(one: simple(:x)) { 1 }
    rule(two: simple(:x)) { 2 }
    rule(three: simple(:x)) { 3 }
    rule(four: simple(:x)) { 4 }
    rule(five: simple(:x)) { 5 }
    rule(six: simple(:x)) { 6 }
    rule(seven: simple(:x)) { 7 }
    rule(eight: simple(:x)) { 8 }
    rule(nine: simple(:x)) { 9 }
end

parsed = CjkParser.new.parse("零一二三四五六七八九〇") 
pp CjkTrans.new.apply(parsed)