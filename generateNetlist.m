function [filename,worstPathBarVector, worstPathCrossVector, bestPathBarVector, bestPathCrossVector]  = generateNetlist(N,toUseWaveguides)

    % Check if Base 2 number
    if (N==0 || N==1 || (~(floor(log2(N))==log2(N))))
        disp('Error: Please enter a base 2 number');
        return;
    end

    [outSwitchTop, switchArrayOut, nodeIndex, waveguides, worstPathBarVector, worstPathCrossVector, bestPathBarVector, bestPathCrossVector] = generateSwitch(N, 1, [], 1, 0, 0, [], toUseWaveguides, 2, {}, {}, 1, {}, {});

    % Connect the loner nodes for the SPI netlist
    for i=1:size(switchArrayOut,2)
        for port=1:4
            if (isempty(switchArrayOut(i).ports{port}))
                nodeIndex = switchArrayOut(i).connectLoners(port,nodeIndex);
            end
        end
    end

    header = sprintf('*\n* MAIN CELL: Component pathname : root_element\n*\n   .MODEL MMI_switch_ideal "label 1"="TE" "control"=1\n   .MODEL "Waveguide Crossing" "label 1"="TE" "transmission 1"=0.9954054174 "cross talk 1"=0.0001\n   + "transmission 2"=1 "cross talk 2"=0 "reflection 1"=0.001\n   + "reflection 2"=0 "label 2"="TM" "orthogonal identifier 1"=1\n   + "orthogonal identifier 2"=2\n   .MODEL "Straight Waveguide" "excess loss temperature sensitivity 2"=0 "label 1"="TE" "orthogonal identifier 1"=1 \n   + "loss 1"=0 "number of taps"=64 "dispersion 1"=0 \n   + "effective index temperature sensitivity 2"=0 "effective index 2"=1 length=10u \n   + "group index 2"=1 "orthogonal identifier 2"=2 "nominal temperature"=300 \n   + "loss 2"=0 "dispersion 2"=0 frequency=193.1T \n   + "digital filter"=0 "run diagnostic"=0 "window function"="rectangular" \n   + "thermal fill factor"=1 "excess loss temperature sensitivity 1"=0 "label 2"="TM" \n   + "thermal effects"=0 "effective index temperature sensitivity 1"=0 "effective index 1"=1 \n');
    switch_str = ' MMI_switch_ideal library="Design kits/capstone" sch_x=%s sch_y=%s sch_r=0 sch_f=false lay_x=0 lay_y=0';
    crossing_str = ' "Waveguide Crossing" sch_x=%s sch_y=%s sch_r=0 sch_f=false lay_x=0 lay_y=0';
    waveguide_str = ' "Straight Waveguide" sch_x=%s sch_y=%s sch_r=0 sch_f=false lay_x=0 lay_y=0 ';
    footer = sprintf('*\n.end');
    subckt_header = '.subckt HDBE ';
    subckt_footer = '.ends HDBE';
    all_the_nodes = '';
    ckt_declaration = 'HDBE %s HDBE sch_x=0 sch_y=0';
    ona = '* - ONA\n.ona input_unit=wavelength input_parameter=center_and_range center=1550e-9\n  + range=100e-9 number_of_points=100 \n  + minimum_loss=200\n  + sensitivity=-200 \n  + analysis_type=scattering_data\n  + multithreading=user_defined number_of_threads=1 \n %s  %s';
    ona_inputs = '';
    ona_output = '';

    toUseWaveguides_str = '_(without_waveguides)';
    if (toUseWaveguides ~= 0)
        toUseWaveguides_str = '_(with_waveguides)';
    end
    filename = [num2str(N) 'x' num2str(N) toUseWaveguides_str '.spi'];
    fid = fopen(filename,'w');
    disp(header); fprintf(fid, [header '\n']);

    for i = 1:size(outSwitchTop, 2)
        if (i == 1)
            ona_output = strcat('+ output=HDBE, ', outSwitchTop(i).ports{1}, '\n'); 
        end

        if (i <= size(outSwitchTop,2)/2)
            all_the_nodes = [all_the_nodes, ' ', outSwitchTop(i).ports{1}];
        else 
            all_the_nodes = [all_the_nodes, ' ', outSwitchTop(i).ports{3}];
            ona_inputs = strcat(ona_inputs, '+ input(', num2str(i-size(outSwitchTop,2)/2), ')=HDBE, ', outSwitchTop(i).ports{3}, '\n'); 
        end
    end
    subckt_header = [subckt_header, all_the_nodes];
    disp(subckt_header); fprintf(fid, [subckt_header '\n']);

    for i = 1:size(switchArrayOut, 2)
        msg = sprintf('   %s %s %s %s %s', switchArrayOut(i).name, ...
                switchArrayOut(i).ports{1}, switchArrayOut(i).ports{2}, ...
                switchArrayOut(i).ports{3}, switchArrayOut(i).ports{4});
        if (switchArrayOut(i).name(1) == 'C')
           if (toUseWaveguides ~= 0)
               msg = strcat(msg, sprintf(crossing_str, num2str(2*switchArrayOut(i).x), num2str(switchArrayOut(i).y)));
           else
               msg = strcat(msg, sprintf(crossing_str, num2str(switchArrayOut(i).x), num2str(switchArrayOut(i).y)));
           end
        elseif (switchArrayOut(i).name(1) == 'S')

           if (toUseWaveguides ~= 0)
               msg = strcat(msg, sprintf(switch_str, num2str(2*switchArrayOut(i).x), num2str(switchArrayOut(i).y)));
           else
               msg = strcat(msg, sprintf(switch_str, num2str(switchArrayOut(i).x), num2str(switchArrayOut(i).y)));
           end
        end
        disp(msg); fprintf(fid, [msg '\n']);
    end
    for i = 1:size(waveguides, 2)
           msg = sprintf('   %s %s %s', waveguides(i).name, ...
                    waveguides(i).ports{1}, waveguides(i).ports{2});
           if (toUseWaveguides ~= 0)     
               msg = strcat(msg, sprintf(waveguide_str, num2str(2*waveguides(i).x), num2str(waveguides(i).y)));
           else
               msg = strcat(msg, sprintf(waveguide_str, num2str(waveguides(i).x), num2str(waveguides(i).y)));
           end
           disp(msg); fprintf(fid, [msg '\n']);
    end

    disp(subckt_footer); fprintf(fid, [subckt_footer '\n']);
    disp(sprintf(ona, ona_inputs, ona_output)); fprintf(fid, [sprintf(ona, ona_inputs, ona_output), '\n']);

    disp(sprintf(ckt_declaration, all_the_nodes)); fprintf(fid, [sprintf(ckt_declaration, all_the_nodes), '\n']);
    disp(footer); fprintf(fid, footer);
    fclose(fid);

end