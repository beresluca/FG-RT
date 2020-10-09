%% (1) basics - loading data, extracting variables of interest, preallocating results array

load sub2Log.mat;
RT_all = cell2mat(logVar(2:end,12));
blockIndices = cell2mat(logVar(2:end, 2));
figPresent = cell2mat(logVar(2:end, 7));  % binary vector
stim_difficulty = cell2mat(logVar(2:end,5));

% somehow extract the easy-difficult distinction in a general way:
diffValues = [min(unique(stim_difficulty)), max(unique(stim_difficulty))]; 
isDifficult = stim_difficulty==diffValues(2);  % binary vector

% what will our results look like
subRT = nan(20, 10, 2, 2);


%% (2) sort RTs into categories, store it in output variable

for blockIdx = 1:10
    
  for fig = 0:1
      
      for diff = 0:1
                       
            subRT(:, blockIdx, fig +1, diff +1) = RT_all(blockIndices==blockIdx & figPresent==fig & isDifficult==diff);

      end 
  end 
  
end

% needed another 4D matrix where blocks are merged together 
subRT_types = nan(200,1,2,2);

 for fig = 0:1
      
      for diff = 0:1
                       
            subRT_types(:, :, fig +1, diff +1) = RT_all(figPresent==fig & isDifficult==diff);

      end 
 end    


mean_stmType = mean(subRT_types);
sd_stmType = std(subRT_types); 

% first row mean, second row SD
Mean_SD_stmType = vertcat(mean_stmType, sd_stmType);

%% (3) optional - report some basic stuff: 
% mean & SD of RT for the 2 X 2 structure for the overall task (all blocks combined)
% mean & SD of RT for the 2 X 2 structure per block (+ per stimulus type) 

mean_RT = mean(subRT(:), 'omitnan'); % omit NAN values
sd_RT = std(subRT(:), 'omitnan'); 

% Means & SD arranged in a 4D matrix

mean_RT_blocks = nan(1,10);
sd_RT_blocks = nan(1,10);

for blockIdx = 1:10
    
    for fig = 0:1
        
        for diff = 0:1
            
            mean_RT_blocks(:, blockIdx, fig +1, diff +1) = mean(subRT(:, blockIdx, fig +1, diff +1), 'omitnan');
            sd_RT_blocks(:, blockIdx, fig +1, diff +1) = std(subRT(:, blockIdx, fig +1, diff +1), 'omitnan');
           
        end
    end
end

% first row = mean, second row = sd
Mean_SD_blocks = vertcat(mean_RT_blocks, sd_RT_blocks);


%% Mean and SD per blocks (1-10) and overall by stimlus type (11th column) 

Behav_all = horzcat(Mean_SD_blocks, Mean_SD_stmType);

% disp([newline 'Mean RT: ', num2str(mean_RT)]);
% disp([newline '  SD RT: ', num2str(sd_RT)]);
% 
% disp([newline 'Mean & SD per blocks']);
% disp(Mean_SD_blocks);


%% Plots
% per blocks and stimulus type 

figure(1)

hold on 
for fig = 0:1
   
    for diff = 0:1
        
        plot(mean_RT_blocks(:,:,fig+1,diff+1));      
        
    end 
end
 
legend('fig absent / easy', 'figure absent / diff', 'figure present / easy', 'figure present / diff');

figure(2)
bar(mean_stmType(:));
% need to add labels 


