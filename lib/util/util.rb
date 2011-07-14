module Rumerical
  module Util
    def deepcopy o
      Marshal.load(Marshal.dump(o))
    end
  end
end
