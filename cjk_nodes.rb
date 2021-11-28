PureExpressionNode = Struct.new(:args) do
    def eval
        figure = 1
        sum = args.reverse.inject(0) {|result, item|
         result = result + item * figure
         figure *= 10
         result
        }
        sum.to_i
    end
end

Layer1ExpressionNode = Struct.new(:left, :unit, :right) do
    def eval
        l = left ? left.eval : 1
        r = right ? right.eval : 0
        l * unit + r
    end
end

Layer2ExpressionNode = Struct.new(:left, :unit, :right) do
    def eval
        l = left ? left.eval : 1
        r = right ? right.eval : 0
        l * unit + r
    end
end