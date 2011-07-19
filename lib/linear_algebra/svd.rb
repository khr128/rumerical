module Rumerical
  module LinearAlgebra
    attr_reader :u, :v, :w
    MAX_SVD_ITERATIONS = 300
    def svdcmp
      @u = deepcopy self
      @w = Rumerical::Matrix.new({})
      @v = Rumerical::Matrix.new({})
      rv1 = Rumerical::Matrix.new({})
      n = @u.rect.col
      m = @u.rect.row

      g=scale=anorm=0.0
      (1..n).each do |i|
        l = i+1
        rv1[i,1] = scale*g
        g=s=scale=0.0
        if i <= m
          scale = (i..m).inject(0.0){|sum,k| sum + @u[k,i].abs}

          unless scale == 0.0
            (i..m).each do |k|
              @u[k,i] /= scale
              s += @u[k,i]*@u[k,i]
            end
            f = @u[i,i]
            g = -transfer_sign(Math::sqrt(s), f)
            h = f*g-s
            @u[i,i] = f-g
            (l..n).each do |j|
              f = (i..m).inject(0.0) {|sum,k| sum + @u[k,i]*@u[k,j]}/h
              (i..m).each{|k| @u[k,j] += f*@u[k,i]}
            end
            (i..m).each{|k| @u[k,i] *= scale}
          end
        end

        @w[i,1] = scale*g
        g=s=scale=0.0
        if i <= m && i != n
          scale = (l..n).inject(0.0){|sum,k| sum + @u[i,k].abs}
          unless scale == 0.0
            (l..n).each do |k|
              @u[i,k] /= scale
              s += @u[i,k]*@u[i,k]
            end
            f = @u[i,l]
            g = -transfer_sign(Math::sqrt(s), f)
            h = f*g-s
            @u[i,l] = f-g
            (l..n).each{|k| rv1[k,1] = @u[i,k]/h}
            (l..m).each do |j|
              s = (l..n).inject(0.0) {|sum,k| sum + @u[j,k]*@u[i,k]}
              (l..n).each{|k| @u[j,k] += s*rv1[k,1]}
            end
            (l..n).each{|k| @u[i,k] *= scale}
          end
        end
        anorm = [anorm, @w[i,1].abs + rv1[i,1].abs].max
      end

      n.downto(1).each do |i|
        if i < n
          l = i+1
          if g != 0.0
            (l..n).each{|j| @v[j,i] = (@u[i,j]/@u[i,l])/g}
            (l..n).each do |j|
              s = (l..n).inject(0.0) {|sum,k| sum + @u[i,k]*@v[k,j]}
              (l..n).each{|k| @v[k,j] += s*@v[k,i]}
            end
          end
          (l..n).each{|j| @v[i,j]=@v[j,i]=0.0}
        end
        @v[i,i] = 1.0
        g = rv1[i,1]
      end

      [m,n].min.downto(1).each do |i|
        l = i+1
        g = @w[i,1]
        (l..n).each{|j| @u[i,j] = 0.0}
        if g != 0.0
          g = 1.0/g
          (l..n).each do |j|
            s = (l..m).inject(0.0) {|sum,k| sum + @u[k,i]*@u[k,j]}
            f = (s/@u[i,i])*g
            (i..m).each{|k| @u[k,j] += f*@u[k,i]}
          end
          (i..m).each{|j| @u[j,i] *= g}
        else
          (i..m).each{|j| @u[j,i] = 0.0}
        end
        @u[i,i] += 1.0
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
            if (@w[nm,1].abs + anorm) == anorm
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
              g = @w[i,1]
              h = pythag(f,g)
              @w[i,1] = h
              h = 1.0/h
              c = g*h
              s = -f*h
              (1..m).each do |j|
                y = @u[j,nm]
                z = @u[j,i]
                @u[j,nm] = y*c + z*s
                @u[j,i] = z*c - y*s
              end
            end
          end

          z = @w[k,1]
          if l == k
            if z < 0.0
              @w[k,1] = -z
              (1..n).each{|j| @v[j,k] = -@v[j,k]}
            end
            break
          end

          raise "svd: no convergence in #{MAX_SVD_ITERATIONS} svdcmp iterations" if its == MAX_SVD_ITERATIONS

          x = @w[l,1]
          nm = k-1
          y = @w[nm,1]
          g = rv1[nm,1]
          h = rv1[k,1]
          f = ((y-z)*(y+z)+(g-h)*(g+h))/(2.0*h*y)
          g = pythag(f,1.0)
          f = ((x-z)*(x+z) + h*((y/(f+transfer_sign(g,f))) - h))/x

          c=s=1.0
          (l..nm).each do |j|
            i = j+1
            g = rv1[i,1]
            y = @w[i,1]
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
              x = @v[jj, j]
              z = @v[jj, i]
              @v[jj,j] = x*c + z*s
              @v[jj,i] = z*c - x*s
            end

            z = pythag(f,h)
            @w[j,1] = z
            if z != 0 
              z = 1.0/z
              c = f*z
              s = h*z
            end

            f = c*g + s*y
            x = c*y - s*g

            (1..m).each do |jj|
              y = @u[jj, j]
              z = @u[jj, i]
              @u[jj,j] = y*c + z*s
              @u[jj,i] = z*c - y*s
            end
          end
          rv1[l,1] = 0.0
          rv1[k,1] = f
          @w[k,1] = x
        end
      end
    end #end of svdcmp
  end
end
