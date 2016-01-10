classdef Waveguide < Thing
   properties
       name = '';
       ports;
       x;
       y;
   end
    
   methods
       
       function obj = Waveguide(name, x, y)
           if(nargin > 0)
               obj.name = name;
               obj.ports = cell(1, 2);
               obj.x = x;
               obj.y = y;
           end
       end
       
       function y = connect(n)
       end
           
   end
    
end