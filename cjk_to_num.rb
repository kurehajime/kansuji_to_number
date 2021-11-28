require 'parslet' 
require_relative 'cjk_parser'
require_relative 'cjk_nodes'
require_relative 'cjk_trans'
module CjkToNumber
    def self.parse(str)
        CjkToNumber::CjkParser.new.parse(str) 
    end

    def self.trans(str)
        parsed = CjkToNumber::CjkParser.new.parse(str) 
        transed = CjkToNumber::CjkTrans.new.apply(parsed)
        transed.eval
    end
end
