module Rumerical
  module Util
    TINY = 1.0e-20
    def deepcopy o
      Marshal.load(Marshal.dump(o))
    end
    def transfer_sign a,b
      b > 0 ? a.abs : -a.abs
    end

    def sqr x
      x*x
    end

    def pythag a,b
      absa = a.abs
      absb = b.abs
      return absa*Math::sqrt(1.0+sqr(absb/absa)) if absa > absb
      absb == 0.0 ? 0.0 : absb*Math::sqrt(1.0 + sqr(absa/absb))
    end
  end
end
