classdef Thing < handle
   properties (Abstract)
       name;
       ports;
   end
    
   methods (Abstract)
       
       connect(obj, thing, port)
           
   end
    
end