require 'parslet' 
require_relative 'cjk_parser'
require_relative 'cjk_nodes'
require_relative 'kansuji_trans'
module KansujiToNumber
    def self.parse(str)
        KansujiToNumber::CjkParser.new.parse(str) 
    end

    def self.trans(str)
        parsed = KansujiToNumber::CjkParser.new.parse(str) 
        transed = KansujiToNumber::KansujiTrans.new.apply(parsed)
        transed.eval
    end
end
