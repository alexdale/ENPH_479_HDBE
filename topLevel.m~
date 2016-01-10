clc;clear;
N=8;
toUseWaveguides = 0;
toUseBestPath = 1; % put 0 for worst path

% Get the name of the netlist file (already saved to disk)
[netlistFile, worstPathBarVector, worstPathCrossVector, bestPathBarVector, bestPathCrossVector] = generateNetlist(N,toUseWaveguides);

% Write the Lumerical INTERCONNECT start-up script
lsfFile = 'temp.lsf';
fid = fopen(lsfFile, 'w');
text_lsf = 'switchtolayout;\n';
text_lsf = [text_lsf 'deleteall;\n'];

text_lsf = [text_lsf sprintf('importnetlist("%s");\n', netlistFile)];
% Set the cross switches (CURRENTLY ONLY DOES WORST PATH)
if toUseBestPath == 1
    crossingVector = bestPathCrossVector;
else
    crossingVector = worstPathCrossVector;
end
for i=1:numel(crossingVector)
   text_lsf = [text_lsf sprintf('select("HDBE::%s");\n', crossingVector{i}.name)]
   text_lsf = [text_lsf 'set("control", 0);\n']
end
text_lsf = [text_lsf 'run;\n'];
text_lsf = [text_lsf 'results = getresult("ONA_1");\n'];
 for i=1:N
  text_lsf = [text_lsf sprintf('if (findstring(results, "input %s")!=-1) {\n', num2str(i))]
  text_lsf = [text_lsf sprintf('  t%s = getresult("ONA_1", "input %s/mode 1/gain");}\n',num2str(i), num2str(i))];
 end
 % Add _best or _worst to .mat file path
netlistFile = strrep(netlistFile,'.spi','');
if toUseBestPath == 1
    bestOrWorst = '_best';
else
    bestOrWorst = '_worst';
end
netlistFile = [netlistFile bestOrWorst];
text_lsf =[text_lsf sprintf('matlabsave("%s");\n', netlistFile)];

fprintf(fid, text_lsf);
fclose(fid);
disp(text_lsf);

if ismac
  % OSX specific
  disp('Running INTERCONNECT')
  path = pwd;
  str = ['sudo open -n /Applications/Lumerical/INTERCONNECT/INTERCONNECT.app --args -run ', path, '/', lsfFile];
  system(str)

elseif ispc
  % Windows specific code here
  disp('Running INTERCONNECT')
  system(['start D:\INTERCONNECT_beta\bin\interconnect.exe -run ' lsfFile]);
end
