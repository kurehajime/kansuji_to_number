require 'parslet' 
require_relative 'kansuji_parser'
require_relative 'kansuji_trans'
module KansujiToNumber
    def self.parse(str)
        KansujiToNumber::KansujiParser.new.parse(str.strip) 
    end

    def self.trans(str)
        parsed = KansujiToNumber::KansujiParser.new.parse(str.strip) 
        transed = KansujiToNumber::KansujiTrans.new.apply(parsed)
        transed.eval
    end
end
