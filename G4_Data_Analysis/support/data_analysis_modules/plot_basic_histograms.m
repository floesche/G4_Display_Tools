%% plot data
%calculate overall measurements and plot basic histograms
function plot_basic_histograms(timeseries_data, interhistogram_data, ...
    TC_datatypes, plot_settings, num_groups, num_exps, genotype, TC_inds, trial_options, ...
    annotation_settings, single)

    %Set up needed variables
    rep_Colors = plot_settings.rep_colors;
    mean_Colors = plot_settings.mean_colors;
    rep_LineWidth = plot_settings.rep_LineWidth;
    mean_LineWidth = plot_settings.mean_LineWidth;
    subtitle_FontSize = plot_settings.subtitle_FontSize/1.25;
    ann_textbox = annotation_settings.textbox;
    ann_dates = annotation_settings.date_range;
    ann_fontSize = annotation_settings.font_size/1.25;
    ann_fontName = annotation_settings.font_name;
    ann_lineStyle = annotation_settings.line_style;
    ann_edgeColor = annotation_settings.edge_color;
    ann_lineWidth = annotation_settings.line_width;
    ann_backgroundColor = annotation_settings.background_color;
    ann_color = annotation_settings.color;
    ann_interpreter = annotation_settings.interpreter;
    plot_in_degrees = plot_settings.inter_in_degrees;
    

    num_TC_datatypes = length(TC_datatypes);
    
    if num_groups > 5
        for i = 1:ceil(num_groups/5)
            if i == ceil(num_groups/5)
                groups(i) = rem(num_groups,5);
            else
                groups(i) = 5;
            end
        end
        
    else
        
        groups = num_groups;
    end
    g = 0;
    for k = 1:length(groups)
        num_plot_groups = groups(k);
        figure();
        for plot_group = 1:num_plot_groups
            g = g + 1;
            for d = 1:num_TC_datatypes
                data_vec = reshape(timeseries_data(g,:,TC_inds(d),:,:),[1 numel(timeseries_data(g,:,d,:,:))]);
                datastr = TC_datatypes{d};
                datastr(strfind(datastr,'_')) = '-'; %convert underscores to dashes to prevent subscripts

                subplot(2+num_TC_datatypes,num_plot_groups,plot_group)
                text(0.1, 1.25-0.3*d, ['Mean ' TC_datatypes{d} ' = ' num2str(nanmean(data_vec))], 'FontSize', 8);
                axis off
                hold on
        %         title(['Group ' num2str(g)],'FontSize',subtitle_FontSize);
                genotypeStr = convertCharsToStrings(genotype{g});
                num_expsStr = convertCharsToStrings(num_exps);        
                title(genotypeStr,'FontSize',subtitle_FontSize);
                %text
    %             annotation('textbox',[0.3 0.0001 0.7 0.027],'String',"empty split: " + e + " flies run from 08/08/19 to 08/13/19", ...
    %                 'FontSize' ,10,'FontName','Arial','LineStyle','-','EdgeColor',[1 1 1],'LineWidth',1,'BackgroundColor',[1 1 1],'Color',[0 0 0],'Interpreter', 'none'); %e is number of experiments
                

                annotation('textbox', ann_textbox, 'String', genotypeStr + ": " + num_expsStr + " flies run from " + ann_dates, ...
                    'FontSize', ann_fontSize, 'FontName', ann_fontName, 'LineStyle', ann_lineStyle, ...
                    'EdgeColor', ann_edgeColor, 'LineWidth', ann_lineWidth, 'BackgroundColor', ann_backgroundColor, ...
                    'Color', ann_color, 'Interpreter', ann_interpreter);

                subplot(2+num_TC_datatypes,num_plot_groups,d*num_plot_groups+plot_group)
                avg = length(data_vec)/100;
                histogram(data_vec,100)
                hold on
                xl = xlim;
                plot(xl,[avg avg],'--','Color',rep_Colors(g,:)','LineWidth',mean_LineWidth)
                title(datastr,'FontSize',subtitle_FontSize);
                currPlot = gca;
                set(currPlot, 'FontSize', 8);
            end

            if trial_options(2)==1 && single == 0
                
                ind_lines = squeeze(nanmean(interhistogram_data(g,:,:,:),3));
                avg_line = squeeze(nanmean(nanmean(interhistogram_data(g,:,:,:),3),2));
                if plot_in_degrees == 1
                
                    half = size(ind_lines,2)/2;
                    for i = 1:size(ind_lines,1)
                        ind_lines(i,:) = [ind_lines(i,half+1:end), ind_lines(i, 1:half)];
                    end
                    
                    avg_line(:,1) = [avg_line(half+1:end); avg_line(1:half)];
                end
 
                subplot(2+num_TC_datatypes,num_plot_groups,(1+num_TC_datatypes)*num_plot_groups+plot_group)
                plot(ind_lines','Color',rep_Colors(g,:),'LineWidth',rep_LineWidth)
                hold on   
                plot(avg_line,'Color',mean_Colors(g,:),'LineWidth',mean_LineWidth)
                
                %convert x axis to degrees
               if plot_in_degrees == 1
                    x = xlim;
                    x = x(2);
                    tickgap = x/10;
                    for k = 1:11
                        tick_labels(k) = (-180 + (36*k) - 36);
                        ticks(k) = k*tickgap - tickgap;
                    end

                    xticks(ticks);

                    xticklabels(string(tick_labels));
                    xlabel('Degrees');
               end

                title('Intertrial Pattern Frame','FontSize',subtitle_FontSize)
                currPlot = gca;
                set(currPlot, 'FontSize', 8);
            
            elseif trial_options(2) == 1 && single == 1
                
                fly_line = squeeze(nanmean(interhistogram_data(g,:,:,:),3));
                if plot_in_degrees == 1
                    
                    half = length(fly_line)/2;
                    fly_line = [fly_line(half+1:end); fly_line(1:half)];
                    
                end
                
                subplot(2+num_TC_datatypes,num_plot_groups,(1+num_TC_datatypes)*num_plot_groups+plot_group)
                plot(fly_line','Color',rep_Colors(g,:),'LineWidth',rep_LineWidth)
                
                if plot_in_degrees == 1
                     x = xlim;
                    x = x(2);
                    tickgap = x/10;
                    for k = 1:11
                        tick_labels(k) = (-180 + (36*k) - 36);
                        ticks(k) = k*tickgap - tickgap;
                    end
                    xticks(ticks);

                    xticklabels(string(tick_labels));
                    xlabel('Degrees');
               end
                
            
            end


        end
    end
    
%     currgraph = gcf;
%     currPosition = get(currgraph, 'Position');
%     screen = get(0,'ScreenSize');
%     if num_groups <= 3
%         %do nothing
%     elseif num_groups <= 6
% 
%         newPosition = [10, 10, screen(3)*.5, screen(4)*.5];
%         set(currgraph, 'Position', newPosition);
%     else
%         newPosition = [10,10, screen(3)*.8, screen(4)*.8];
%         set(currgraph, 'Position', newPosition);
%     end
end

