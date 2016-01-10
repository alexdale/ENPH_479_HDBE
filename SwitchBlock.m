classdef SwitchBlock < Thing
   properties
       name = '';
       ports;
       x;
       y;
   end
    
   methods
       
       function obj = SwitchBlock(name, x, y)
           if(nargin > 0)
               obj.name = name;
               obj.ports = cell(1, 4);
               obj.x = x;
               obj.y = y;
           end
       end
       
       function [nodeIndex, waveguides] = connect(obj, port, thing, otherPort, nodeIndex, waveguides, toUseWaveguides, reverse)
           if(nargin > 0)
              obj.ports{port} = strcat('N$', num2str(nodeIndex));
              if (toUseWaveguides ~= 0)
                  W = Waveguide(strcat('W', num2str(size(waveguides,2)+1)), (obj.x+thing.x)/2, (obj.y+thing.y)/2);
                  if (nargin > 7)
                    W.ports{2} = strcat('N$', num2str(nodeIndex));
                    nodeIndex = nodeIndex+1;
                    W.ports{1} = strcat('N$', num2str(nodeIndex));
                  else
                    W.ports{1} = strcat('N$', num2str(nodeIndex));
                    nodeIndex = nodeIndex+1;
                    W.ports{2} = strcat('N$', num2str(nodeIndex));
                  end
                  waveguides(size(waveguides,2)+1) = W;
              end
              thing.ports{otherPort} = strcat('N$', num2str(nodeIndex));
              nodeIndex = nodeIndex+1;
           end
       end
       
       function nodeIndex = connectLoners(obj, port, nodeIndex)
           if ~(isempty(obj.ports{port}))
               disp('Error - this port is already connected');
           end
           obj.ports{port} = strcat('N$', num2str(nodeIndex));
           nodeIndex = nodeIndex+1;
       end
   end
    
end