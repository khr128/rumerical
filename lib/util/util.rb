module Rumerical
  module Util
    TINY = 1.0e-20
    def deepcopy o
      Marshal.load(Marshal.dump(o))
    end
  end
end
