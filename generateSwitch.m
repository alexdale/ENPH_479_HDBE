function [outSwitch, switchArrayOut, nodeIndex, waveguides, worstPathBarVector, worstPathCrossVector, bestPathBarVector, bestPathCrossVector] = generateSwitch(N, thingIndex, switchArrayIn, nodeIndex, x, y, waveguides, toUseWaveguides, topOrBottomWorst, worstPathBarVector, worstPathCrossVector, topOrBottomBest, bestPathBarVector, bestPathCrossVector)

    if N == 2
       S1 = SwitchBlock(strcat('S', num2str(thingIndex)), x-3, y+0.75);
       thingIndex = thingIndex + 1;
       S2 = SwitchBlock(strcat('S', num2str(thingIndex)), x-3, y-0.75);
       thingIndex = thingIndex + 1;
       S3 = SwitchBlock(strcat('S', num2str(thingIndex)), x-1, y+1.5);
       thingIndex = thingIndex + 1;   
       S4 = SwitchBlock(strcat('S', num2str(thingIndex)), x-1, y+0.5);
       thingIndex = thingIndex + 1; 
       S5 = SwitchBlock(strcat('S', num2str(thingIndex)), x-1, y-0.5);
       thingIndex = thingIndex + 1; 
       S6 = SwitchBlock(strcat('S', num2str(thingIndex)), x-1, y-1.5);
       thingIndex = thingIndex + 1; 
       S7 = SwitchBlock(strcat('S', num2str(thingIndex)), x+1, y+1.5);
       thingIndex = thingIndex + 1; 
       S8 = SwitchBlock(strcat('S', num2str(thingIndex)), x+1, y+0.5);
       thingIndex = thingIndex + 1; 
       S9 = SwitchBlock(strcat('S', num2str(thingIndex)), x+1, y-0.5);
       thingIndex = thingIndex + 1; 
       S10 = SwitchBlock(strcat('S', num2str(thingIndex)), x+1, y-1.5);
       thingIndex = thingIndex + 1; 
       S11 = SwitchBlock(strcat('S', num2str(thingIndex)), x+3, y+0.75);
       thingIndex = thingIndex + 1; 
       S12 = SwitchBlock(strcat('S', num2str(thingIndex)), x+3, y-0.75);
       thingIndex = thingIndex + 1;
       C1 = SwitchBlock(strcat('C', num2str(thingIndex)), x-2, y);
       thingIndex = thingIndex + 1; 
       C2 = SwitchBlock(strcat('C', num2str(thingIndex)), x, y+1);
       thingIndex = thingIndex + 1; 
       C3 = SwitchBlock(strcat('C', num2str(thingIndex)), x, y-1);
       thingIndex = thingIndex + 1; 
       C4 = SwitchBlock(strcat('C', num2str(thingIndex)), x+2, y);
       thingIndex = thingIndex + 1; 
       
       [nodeIndex, waveguides] = S1.connect(3, S3, 2, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = S1.connect(4, C1, 1, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = S2.connect(3, C1, 2, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = C1.connect(3, S4, 1, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = C1.connect(4, S5, 2, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = S2.connect(4, S6, 1, nodeIndex, waveguides, toUseWaveguides);
       
       [nodeIndex, waveguides] = S3.connect(3, S7, 1, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = S3.connect(4, C2, 1, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = S4.connect(3, C2, 2, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = C2.connect(4, S8, 1, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = C2.connect(3, S7, 2, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = S4.connect(4, S8, 2, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = S5.connect(3, S9, 1, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = S5.connect(4, C3, 1, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = S6.connect(3, C3, 2, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = C3.connect(4, S10, 1, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = C3.connect(3, S9, 2, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = S6.connect(4, S10, 2, nodeIndex, waveguides, toUseWaveguides);

       [nodeIndex, waveguides] = S7.connect(3, S11, 1, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = S8.connect(4, C4, 1, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = S9.connect(3, C4, 2, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = C4.connect(4, S12, 1, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = C4.connect(3, S11, 2, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = S10.connect(4, S12, 2, nodeIndex, waveguides, toUseWaveguides);
       
       % If switchArrayIn is empty, i.e, first ever call, to avoid
       % embedding an empty array we don't include switchArrayIn
       if (size(switchArrayIn, 1) ~= 0)
           switchArrayOut = [switchArrayIn,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,C1,C2,C3,C4];
       else
           switchArrayOut = [S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,C1,C2,C3,C4];
       end
       outSwitch=[S1, S2, S11, S12];
       
       if (topOrBottomWorst == 2)
           worstPathCrossVector{size(worstPathCrossVector,2)+1} = S1;
           worstPathCrossVector{size(worstPathCrossVector,2)+1} = S5;
           worstPathCrossVector{size(worstPathCrossVector,2)+1} = S11;
           
           worstPathBarVector{size(worstPathBarVector,2)+1} = S9;
       end
       
       if (topOrBottomBest == 1)
           bestPathBarVector{size(bestPathBarVector,2)+1} = S1;
           bestPathBarVector{size(bestPathBarVector,2)+1} = S7;
           bestPathBarVector{size(bestPathBarVector,2)+1} = S11;
           
           bestPathCrossVector{size(bestPathCrossVector,2)+1} = S3;
       end
       
    else
       [firstOut, firstOutArray, nodeIndex, waveguidesFirst, worstPathBarVectorFirst, worstPathCrossVectorFirst, bestPathBarVectorFirst, bestPathCrossVectorFirst] = generateSwitch(N/2, thingIndex, switchArrayIn, nodeIndex, x, y+N/2, waveguides, toUseWaveguides, 1, worstPathBarVector, worstPathCrossVector, topOrBottomBest, bestPathBarVector, bestPathCrossVector);
       [secondOut, firstOutArray2, nodeIndex, waveguides, worstPathBarVector, worstPathCrossVector, bestPathBarVector, bestPathCrossVector] = generateSwitch(N/2, size(firstOutArray,2)+1, firstOutArray, nodeIndex, x, y-N/2, waveguidesFirst, toUseWaveguides, topOrBottomWorst, worstPathBarVectorFirst, worstPathCrossVectorFirst, 2, bestPathBarVectorFirst, bestPathCrossVectorFirst);
       innerSwitchesIs = [firstOut(1:N/2), secondOut(1:N/2)];
       innerSwitchesOs = [firstOut(N/2+1:end), secondOut(N/2+1:end)];
       currSwitchIndex = size(firstOutArray2, 2) + 1;
       
       % This generates the leftmost column of switches
       for i = 1:N
            inputs(i) = SwitchBlock(strcat('S',num2str(currSwitchIndex)), x-(2*N-1), y+N+1-(2*i));
            currSwitchIndex = currSwitchIndex + 1;
       end
       
       startIndex = N;
       lastStartIndex = 1;
       for i = 1:N-1
           crossingsYPos(i) = y+N-(2*i);
       end
       for i = 2:N-1        
           % Creates the switchblocks (in column chunks)
           k = 0;
           for j = startIndex:(i*N-i*(i+1)/2)
              crossingsYPos(j) = crossingsYPos(lastStartIndex + k)-1;
              k = k+1;
           end
           
           lastStartIndex = startIndex;
           startIndex = j+1;
       end
       
       % Generate (N(N-1)/2) WaveguideCrossing's and interconnect them 
       startIndex = 1;
       % There are N-1 columns of crossings
       for i = 1:N-1        
           % Creates the switchblocks (in column chunks)
           for j = startIndex:(i*N-i*(i+1)/2)
              C(j-startIndex+1) = SwitchBlock(strcat('C', num2str(currSwitchIndex)), x-(2*(N/2)-1)-(N-i), crossingsYPos(j));
              currSwitchIndex = currSwitchIndex + 1;
           end
           
           inputCrossings{i} = C;
           clear C;
           startIndex = j+1;
           
           % For the first column of crossings, connect input switches to
           % crossings
           if i==1
               for k=1:numel(inputCrossings{i})
                    [nodeIndex, waveguides] = inputCrossings{i}(k).connect(1, inputs(k), 4, nodeIndex, waveguides, toUseWaveguides, 'reverse');
                    [nodeIndex, waveguides] = inputCrossings{i}(k).connect(2, inputs(k+1), 3, nodeIndex, waveguides, toUseWaveguides, 'reverse');
               end
           % Otherwise, connect crossings to crossings
           else
               for k=1:numel(inputCrossings{i})
                    [nodeIndex, waveguides] = inputCrossings{i}(k).connect(1, inputCrossings{i-1}(k), 4, nodeIndex, waveguides, toUseWaveguides, 'reverse');
                    [nodeIndex, waveguides] = inputCrossings{i}(k).connect(2, inputCrossings{i-1}(k+1), 3, nodeIndex, waveguides, toUseWaveguides, 'reverse');
               end               
           end
       end
       
       % Connect second column switches (left) to crossings (top half)
       for i = 1:N-1
           [nodeIndex, waveguides] = inputCrossings{i}(1).connect(3, innerSwitchesIs(floor(i/2)+1), 2-mod(i+1, 2), nodeIndex, waveguides, toUseWaveguides);
       end     
       % Connect second column switches (left) to crossings (bottom half)
       for i = N-1:-1:1
           [nodeIndex, waveguides] = inputCrossings{i}(numel(inputCrossings{i})).connect(4,innerSwitchesIs(ceil((N-i)/2)+N/2),2-mod(i,2), nodeIndex, waveguides, toUseWaveguides);
       end
       % Do the very top and bottom crossings 
       [nodeIndex, waveguides] = inputs(1).connect(3, innerSwitchesIs(1), 1, nodeIndex, waveguides, toUseWaveguides);
       [nodeIndex, waveguides] = inputs(N).connect(4, innerSwitchesIs(N), 2, nodeIndex, waveguides, toUseWaveguides);
       
       % Create the rightmost row of switches
       for i = 1:N
            outputs(i) = SwitchBlock(strcat('S', num2str(currSwitchIndex)), x+(2*N-1), y+N+1-(2*i));
            currSwitchIndex = currSwitchIndex + 1;
       end
       
       % Generate (N(N-1)/2) WaveguideCrossing's and interconnect them 
       startIndex = 1;
       % There are N-1 columns of crossings
       for i = 1:N-1        
           % Creates the switchblocks (in column chunks)
           for j = startIndex:(i*N-i*(i+1)/2)
              C(j-startIndex+1) = SwitchBlock(strcat('C', num2str(currSwitchIndex)), x+(2*(N/2)-1)+(N-i), crossingsYPos(j));
              currSwitchIndex = currSwitchIndex + 1;
           end
           
           outputCrossings{i} = C;
           clear C;
           startIndex = j+1;
           
           % For the Right column of crossings (i=1), connect output switches to
           % crossings
           if i==1
               for k=1:numel(outputCrossings{i})
                    [nodeIndex, waveguides] = outputCrossings{i}(k).connect(3, outputs(k), 2, nodeIndex, waveguides, toUseWaveguides);
                    [nodeIndex, waveguides] = outputCrossings{i}(k).connect(4, outputs(k+1), 1, nodeIndex, waveguides, toUseWaveguides);
               end
           % Otherwise, connect crossings to crossings
           else
               for k=1:numel(outputCrossings{i})
                    [nodeIndex, waveguides] = outputCrossings{i}(k).connect(3, outputCrossings{i-1}(k), 2, nodeIndex, waveguides, toUseWaveguides);
                    [nodeIndex, waveguides] = outputCrossings{i}(k).connect(4, outputCrossings{i-1}(k+1), 1, nodeIndex, waveguides, toUseWaveguides);
               end               
           end
       end
       
       % Connect second column from right switches to crossings (top half)
       for i = 1:N-1
           [nodeIndex, waveguides] = outputCrossings{i}(1).connect(1, innerSwitchesOs(floor(i/2)+1), 4-mod(i+1, 2), nodeIndex, waveguides, toUseWaveguides, 'reverse');
       end     
       % Connect second column from right switches to crossings (bottom half)
       for i = N-1:-1:1
           [nodeIndex, waveguides] = outputCrossings{i}(numel(outputCrossings{i})).connect(2,innerSwitchesOs(ceil((N-i)/2)+N/2),4-mod(i,2), nodeIndex, waveguides, toUseWaveguides, 'reverse');
       end
       % Do the very top and bottom crossings 
       [nodeIndex, waveguides] = outputs(1).connect(1, innerSwitchesOs(1), 3, nodeIndex, waveguides, toUseWaveguides, 'reverse');
       [nodeIndex, waveguides] = outputs(N).connect(2, innerSwitchesOs(N), 4, nodeIndex, waveguides, toUseWaveguides, 'reverse');
       
       % Make inputCrossingsAccumulated
       inputCrossingsAccumulated = {};
       outputCrossingsAccumulated = {};
       for i = 1:N-1
           inputCrossingsAccumulated = [inputCrossingsAccumulated, inputCrossings{i}];
           outputCrossingsAccumulated = [outputCrossingsAccumulated, outputCrossings{i}];
       end
       
       switchArrayOut = [inputs, inputCrossingsAccumulated, firstOutArray2, outputCrossingsAccumulated, outputs];
       outSwitch=[inputs, outputs];
       
       if (topOrBottomWorst == 2)
           worstPathCrossVector{size(worstPathCrossVector,2)+1} = inputs(1);
           worstPathCrossVector{size(worstPathCrossVector,2)+1} = outputs(1);
       end
       
       if (topOrBottomBest == 1)
           bestPathBarVector{size(bestPathBarVector,2)+1} = inputs(1);
           bestPathBarVector{size(bestPathBarVector,2)+1} = outputs(1);
       end
    end
       
end

