classdef WaveguideCrossing < Thing
   properties
       name = '';
       ports;
   end
    
   methods
       
       function obj = WaveguideCrossing(name)
           if(nargin > 0)
               obj.name = name;
               obj.ports = cell(1, 4);
           end
       end
       
       function nodeIndex = connect(obj, port, thing, otherPort, nodeIndex)
           if(nargin > 0)
              obj.ports{port} = strcat('N$', num2str(nodeIndex));%strcat(thing.name, '-', num2str(otherPort));
              thing.ports{otherPort} = strcat('N$', num2str(nodeIndex));%strcat(obj.name, '-', num2str(port));
              nodeIndex = nodeIndex+1;
           end
       end
           
   end
    
end