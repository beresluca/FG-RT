%% (1) basics - loading data, extracting variables of interest, preallocating results array

fileP = '/home/adamb/FG-RT/sampleData/sub2Log.mat';
load(fileP);
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
                       
            subRT(:, blockIdx, fig+1, diff+1) = RT_all(blockIndices==blockIdx & figPresent==fig & isDifficult==diff);

      end 
  end 
  
end

% needed another 3D matrix where blocks are merged together 
subRT_types = nan(200, 2, 2);

 for fig = 0:1
      
      for diff = 0:1
                       
            subRT_types(:, fig+1, diff+1) = RT_all(figPresent==fig & isDifficult==diff);

      end 
 end    

%%%%%%%%%%%%% adam's comments here %%%%%%%%%%%%%
 % alternative method for merging blocks:
 subRTreshaped = reshape(subRT, [200, 2, 2]);  % elements of input are taken columnwise, working out nicely in our case
 % check if the result is really the same as with the nested for loops
 % above
tmp = isequal(subRT_types, subRTreshaped);
if tmp
    disp('The two methods for merging block-level data yielded the same results');
else
    disp('The two methods for merging block-level data yielded different results!');
end

% get mean and SD for RT per condition
mean_stmType = mean(subRT_types, 'omitnan');  % if there is even one NaN value, the result would be NaN, so we use the "omitnan" flag
sd_stmType = std(subRT_types, 'omitnan'); 
%%%%%%%%%%%%% adam's comments ended %%%%%%%%%%%%


% For me the line below gives a 2x2x2 matrix - was that the intention?

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


%%%%%%%%%%%%% adam's comments here %%%%%%%%%%%%%

% You already have all RT data arranged nicely according to blocks in var
% "subRT". You can simply take the means / SDs along the appropriate
% dimension to obtain block-level mean and SD:

RTblockMean = mean(subRT, 1, 'omitnan');  % mean along first dimension, where size is 20
RTblockSD = std(subRT, 0, 1, 'omitnan');  % std along first dimension - Note the extra input argument! 

% Since our input data might contain NaN values (where there was a missing
% answer), we need to use the "omitnan" flag, otherwise we can easily end
% up with NaN as the result.

% Now we can check if we get the same result as you had above:
RTblockMeanSD = vertcat(RTblockMean, RTblockSD);
tmp = isequal(RTblockMeanSD, Mean_SD_blocks);  % check equality
if tmp
    disp('The two methods for obtaining block-level RT mean and SD yielded the same results');
else
    disp('The two methods for obtaining block-level RT mean and SD yielded different results!');
end

%%%%%%%%%%%%% adam's comments ended %%%%%%%%%%%%
 

%% Mean and SD per blocks (1-10) and overall by stimlus type (11th column) 

%%%%%%%%%%%%% adam's comments here %%%%%%%%%%%%%
% The line below doesn't work for me
%%%%%%%%%%%%% adam's comments ended %%%%%%%%%%%%

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
        
        plot(mean_RT_blocks(:,:,fig+1,diff+1), 'o-');  % added circles for each "real" data point    
        
    end 
end
 
legend('fig absent / easy', 'figure absent / diff', 'figure present / easy', 'figure present / diff');
xlabel('Block no.');
ylabel('Mean RT (ms)');

figure(2)
bar(mean_stmType(:));
% need to add labels 


%%%%%%%%%%%%% adam's comments here %%%%%%%%%%%%%
% For the bar graph:
% The bar graph could take as input a matrix and then it would group
% conditions automatically, according to the matrix structure. And we turn
% the var "mean_stmType" into a 2x2 matrix and just feed it to the bar()
% function

figure(2);
% squeeze and transpose the data so that we group primarily by
% Easy/Difficult categories
tmpData = squeeze(mean_stmType); tmpData = tmpData';
b = bar(tmpData);
% add labels to bars
set(gca,'XTickLabel', {'Easy', 'Difficult'});
% add legend to specify Figure Absent / Present categories
legend('Figure Absent', 'Figure Present');
xlabel('Stimulus types');
ylabel('Mean Rt (ms)');

%%%%%%%%%%%%% adam's comments ended %%%%%%%%%%%%









