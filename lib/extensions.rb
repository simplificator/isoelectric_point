
 class Array
   def count
    k=Hash.new(0)
    self.each{|x| k[x]+=1 }
    k
  end #count
 end #array


 #extend the float class to round off
 class Float
   #round off to the nearest decimal places
   def roundf(places)
     temp = self.to_s.length
     sprintf("%#{temp}.#{places}f",self).to_f
   end
 end

