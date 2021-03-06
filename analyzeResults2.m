clc; clear; clf;

colorOrder = ...
{ [0 0 1] % 1 BLUE
  [0 1 0] % 2 GREEN (pale)
  [1 0 0] }; % 3 RED

switch_designs = {'BDC_switch_ideal', 'BDC_switch_corner', 'MMI_switch_ideal'};
bestOrWorst = 'Best';
param = 'XT'; % IL, XT, or EXR

maximum = 0; minimum = 200;
maxEXR = 0; minEXR = 10000;
legends = {'BDC Switch Ideal', 'BDC Switch Corner', 'MMI Switch Ideal'};
f = zeros(numel(switch_designs)); 
for i = 1:numel(switch_designs)
    n = 2;
    while n <= 16
        name = [switch_designs{i}, '/', bestOrWorst, '/', num2str(n), '.mat'];
        data = load(name);
        if (strcmp(param, 'IL'))
            names = fieldnames(data);
            for j = 1:numel(names)
                if (~strcmp(names{j}, 't1'))
                    data = rmfield(data, names{j});
                end
            end
            
            data = struct2cell(data);
            fieldstr = data{1}.Lumerical_dataset.attributes.variable;
            value = -min(data{1}.(fieldstr)(:));
            if (value < minimum)
                minimum = value;
            end
            if (value > maximum)
                maximum = value;
            end
            
            title(['Insertion Loss of HDBE Switch vs. Switch Size for the ', bestOrWorst, ' Path']);
            xlabel('Size');
            ylabel('Insertion Loss (dB)');
            f(i) = plot(n, value, '.', 'color', colorOrder{i}, 'markers', 20);
            legend(f(1:i), legends(1:i), 'Location', 'NorthWest');
            axis([1 n+1 minimum-1 maximum+1]);
            hold on;
        end
        if (strcmp(param, 'XT'))
            XT = -200;
            names = fieldnames(data);
            for j = 1:numel(names)
                if (strcmp(names{j}, 't1') || strcmp(names{j}, 'results'))
                    data = rmfield(data, names{j});
                end
            end
            data = struct2cell(data);
            for j = 1:numel(data)
                fieldstr = data{j}.Lumerical_dataset.attributes.variable;
                value = max(data{j}.(fieldstr)(:));
                if (XT < value)
                    XT = value;
                end
            end
            if (XT > -minimum)
                minimum = -XT;
            end
            if (XT < maximum)
                maximum = XT;
            end
            
            title(['Crosstalk of HDBE Switch vs. Switch Size for the ', bestOrWorst, ' Path']);
            xlabel('Size');
            ylabel('Crosstalk (dB)');
            f(i) = plot(n, XT, '.', 'color', colorOrder{i}, 'markers', 20);
            legend(f(1:i), legends(1:i), 'Location', 'best');
            axis([1 n+1 maximum-1 -minimum+1]);
            hold on;
        end
        if (strcmp(param, 'EXR'))
            XT = -200; IL = 0;
            dataIL = data;
            names = fieldnames(dataIL);
            for j = 1:numel(names)
                if (~strcmp(names{j}, 't1'))
                    dataIL = rmfield(dataIL, names{j});
                end
            end
            dataIL = struct2cell(dataIL);
            fieldstr = dataIL{1}.Lumerical_dataset.attributes.variable;
            IL = min(dataIL{1}.(fieldstr)(:));
            
            names = fieldnames(data);
            for j = 1:numel(names)
                if (strcmp(names{j}, 't1') || strcmp(names{j}, 'results'))
                    data = rmfield(data, names{j});
                end
            end
            data = struct2cell(data);
            for j = 1:numel(data)
                fieldstr = data{j}.Lumerical_dataset.attributes.variable;
                value = max(data{j}.(fieldstr)(:));
                if (XT < value)
                    XT = value;
                end
            end
            
            EXR = 10*log10((10^(IL/10))/(10^(XT/10)));
            if (EXR > maxEXR)
                maxEXR = EXR;
            end
            if (EXR < minEXR)
                minEXR = EXR;
            end
            
            title(['Extinction Ratio of HDBE Switch vs. Switch Size for the ', bestOrWorst, ' Path']);
            xlabel('Size');
            ylabel('Extinction Ratio (dB)');
            f(i) = plot(n, EXR, '.', 'color', colorOrder{i}, 'markers', 20);
            legend(f(1:i), legends(1:i), 'Location', 'best');
            axis([1 n+1 minEXR-1 maxEXR+1]);
            hold on;
        end

        n = n*2;
    end
end

% % This is currently hardcoded...
% name = '16x16_(with_waveguides)_worst';
% data = load([name,'.mat']);
% 
% % Don't need the results field anymore
% data = rmfield(data,'results');
% legendNames = fieldnames(data);
% data = struct2cell(data);
% h=figure;
% for i = 1:numel(data)
%     fieldstr = data{i}.Lumerical_dataset.attributes.variable;
%     plot(data{i}.wavelength, data{i}.(fieldstr)(:), 'color', rand(1,3))
%     hold on;
% end
% 
% legend(legendNames);
% saveas(h,name,'fig');