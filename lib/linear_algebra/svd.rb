module Rumerical
  module LinearAlgebra
    attr_reader :svd_u, :svd_v, :svd_w
    MAX_SVD_ITERATIONS = 300
    def svdcmp
      @svd_u = deepcopy self
      @svd_w = Rumerical::Matrix.new({})
      @svd_v = Rumerical::Matrix.new({})
      rv1 = Rumerical::Matrix.new({})
      n = @svd_u.rect.col
      m = @svd_u.rect.row

      g=scale=anorm=0.0
      (1..n).each do |i|
        l = i+1
        rv1[i,1] = scale*g
        g=s=scale=0.0
        if i <= m
          scale = (i..m).inject(0.0){|sum,k| sum + @svd_u[k,i].abs}

          unless scale == 0.0
            (i..m).each do |k|
              @svd_u[k,i] /= scale
              s += @svd_u[k,i]*@svd_u[k,i]
            end
            f = @svd_u[i,i]
            g = -transfer_sign(Math::sqrt(s), f)
            h = f*g-s
            @svd_u[i,i] = f-g
            (l..n).each do |j|
              f = (i..m).inject(0.0) {|sum,k| sum + @svd_u[k,i]*@svd_u[k,j]}/h
              (i..m).each{|k| @svd_u[k,j] += f*@svd_u[k,i]}
            end
            (i..m).each{|k| @svd_u[k,i] *= scale}
          end
        end

        @svd_w[i,1] = scale*g
        g=s=scale=0.0
        if i <= m && i != n
          scale = (l..n).inject(0.0){|sum,k| sum + @svd_u[i,k].abs}
          unless scale == 0.0
            (l..n).each do |k|
              @svd_u[i,k] /= scale
              s += @svd_u[i,k]*@svd_u[i,k]
            end
            f = @svd_u[i,l]
            g = -transfer_sign(Math::sqrt(s), f)
            h = f*g-s
            @svd_u[i,l] = f-g
            (l..n).each{|k| rv1[k,1] = @svd_u[i,k]/h}
            (l..m).each do |j|
              s = (l..n).inject(0.0) {|sum,k| sum + @svd_u[j,k]*@svd_u[i,k]}
              (l..n).each{|k| @svd_u[j,k] += s*rv1[k,1]}
            end
            (l..n).each{|k| @svd_u[i,k] *= scale}
          end
        end
        anorm = [anorm, @svd_w[i,1].abs + rv1[i,1].abs].max
      end

      n.downto(1).each do |i|
        if i < n
          l = i+1
          if g != 0.0
            (l..n).each{|j| @svd_v[j,i] = (@svd_u[i,j]/@svd_u[i,l])/g}
            (l..n).each do |j|
              s = (l..n).inject(0.0) {|sum,k| sum + @svd_u[i,k]*@svd_v[k,j]}
              (l..n).each{|k| @svd_v[k,j] += s*@svd_v[k,i]}
            end
          end
          (l..n).each{|j| @svd_v[i,j]=@svd_v[j,i]=0.0}
        end
        @svd_v[i,i] = 1.0
        g = rv1[i,1]
      end

      [m,n].min.downto(1).each do |i|
        l = i+1
        g = @svd_w[i,1]
        (l..n).each{|j| @svd_u[i,j] = 0.0}
        if g != 0.0
          g = 1.0/g
          (l..n).each do |j|
            s = (l..m).inject(0.0) {|sum,k| sum + @svd_u[k,i]*@svd_u[k,j]}
            f = (s/@svd_u[i,i])*g
            (i..m).each{|k| @svd_u[k,j] += f*@svd_u[k,i]}
          end
          (i..m).each{|j| @svd_u[j,i] *= g}
        else
          (i..m).each{|j| @svd_u[j,i] = 0.0}
        end
        @svd_u[i,i] += 1.0
      end

      n.downto(1) do |k|
        (1..MAX_SVD_ITERATIONS).each do |its|
          flag = 1
          l = nm = k
          k.downto(1).each do |ll|
            nm = ll-1
            if (rv1[ll,1].abs + anorm) == anorm
              flag = 0
              l = ll
              break
            end
            if (@svd_w[nm,1].abs + anorm) == anorm
              l = ll
              break 
            end
          end

          if flag != 0
            c = 0.0
            s = 1.0
            (l..k).each do |i|
              f = s*rv1[i,1]
              rv1[i,1] *= c
              break if (f.abs+anorm) == anorm
              g = @svd_w[i,1]
              h = pythag(f,g)
              @svd_w[i,1] = h
              h = 1.0/h
              c = g*h
              s = -f*h
              (1..m).each do |j|
                y = @svd_u[j,nm]
                z = @svd_u[j,i]
                @svd_u[j,nm] = y*c + z*s
                @svd_u[j,i] = z*c - y*s
              end
            end
          end

          z = @svd_w[k,1]
          if l == k
            if z < 0.0
              @svd_w[k,1] = -z
              (1..n).each{|j| @svd_v[j,k] = -@svd_v[j,k]}
            end
            break
          end

          raise "svd: no convergence in #{MAX_SVD_ITERATIONS} svdcmp iterations" if its == MAX_SVD_ITERATIONS

          x = @svd_w[l,1]
          nm = k-1
          y = @svd_w[nm,1]
          g = rv1[nm,1]
          h = rv1[k,1]
          f = ((y-z)*(y+z)+(g-h)*(g+h))/(2.0*h*y)
          g = pythag(f,1.0)
          f = ((x-z)*(x+z) + h*((y/(f+transfer_sign(g,f))) - h))/x

          c=s=1.0
          (l..nm).each do |j|
            i = j+1
            g = rv1[i,1]
            y = @svd_w[i,1]
            h = s*g
            g = c*g
            z = pythag(f,h)
            rv1[j,1] = z
            c = f/z
            s = h/z
            f = x*c + g*s
            g = g*c - x*s
            h = y*s
            y *= c
            (1..n).each do |jj|
              x = @svd_v[jj, j]
              z = @svd_v[jj, i]
              @svd_v[jj,j] = x*c + z*s
              @svd_v[jj,i] = z*c - x*s
            end

            z = pythag(f,h)
            @svd_w[j,1] = z
            if z != 0 
              z = 1.0/z
              c = f*z
              s = h*z
            end

            f = c*g + s*y
            x = c*y - s*g

            (1..m).each do |jj|
              y = @svd_u[jj, j]
              z = @svd_u[jj, i]
              @svd_u[jj,j] = y*c + z*s
              @svd_u[jj,i] = z*c - y*s
            end
          end
          rv1[l,1] = 0.0
          rv1[k,1] = f
          @svd_w[k,1] = x
        end
      end
    end #end of svdcmp
  end
end
