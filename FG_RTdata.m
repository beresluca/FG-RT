%% (1) basics - loading data, extracting variables of interest, preallocating results array

fileS = 'C:\Users\Luca\Documents\mta-ttk anyagok\FG-RT\sampleData\sub2Log.mat';
fileP = '/home/adamb/FG-RT/sampleData/sub2Log.mat';
load(fileS);
RT_all = cell2mat(logVar(2:end,12));
blockIndices = cell2mat(logVar(2:end, 2));
figPresent = cell2mat(logVar(2:end, 7));  % binary vector
stim_difficulty = cell2mat(logVar(2:end,5));
accuracy = cell2mat(logVar(2:end,10));

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
% tmp = isequal(subRT_types, subRTreshaped);
% if tmp
%     disp('The two methods for merging block-level data yielded the same results');
% else
%     disp('The two methods for merging block-level data yielded different results!');
% end

% get mean and SD for RT per condition
mean_stmType = mean(subRT_types, 'omitnan');  % if there is even one NaN value, the result would be NaN, so we use the "omitnan" flag
sd_stmType = std(subRT_types, 'omitnan'); 
%%%%%%%%%%%%% adam's comments ended %%%%%%%%%%%%


% For me the line below gives a 2x2x2 matrix - was that the intention?

%%%%%%%% if subRT_types is 4D, Mean_SD_stmType gives also a 4D, only
%%%%%%%% created 4D for readability issues --> 2x2x2 matrix separates only
%%%%%%%% by difficulty (:,:,1) or (:,:,2)

% first row mean, second row SD
Mean_SD_stmType = vertcat(mean_stmType, sd_stmType);


%% (3) optional - report some basic stuff: 
% mean & SD of RT for the 2 X 2 structure for the overall task (all blocks combined)
% mean & SD of RT for the 2 X 2 structure per block (+ per stimulus type) 

mean_RT = mean(subRT(:), 'omitnan'); % omit NAN values
sd_RT = std(subRT(:), 'omitnan'); 


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
% tmp = isequal(RTblockMeanSD, Mean_SD_blocks);  % check equality
% if tmp
%     disp('The two methods for obtaining block-level RT mean and SD yielded the same results');
% else
%     disp('The two methods for obtaining block-level RT mean and SD yielded different results!');
% end

%%%%%%%%%%%%% adam's comments ended %%%%%%%%%%%%


%% accuracy data - do we need hit/miss, false alarm/correct rejection rates?

%%%%%%%%%%%%% adam's comments here %%%%%%%%%%%%%
% We should do the same with accuracy data as with RT - arrange it
% according to blocks and conditions, then get means and SD
%%%%%%%%%%%%% adam's comments ended %%%%%%%%%%%%

Num_acc = numel(accuracy(accuracy==1));
proportion_acc = Num_acc/800*100;

mean_acc = mean(RT_all(accuracy==1));
sd_acc = std(RT_all(accuracy==1));
mean_inacc = mean(RT_all(accuracy==0));
sd_inacc = std(RT_all(accuracy==0));


%% Mean and SD per blocks (1-10) and overall by stimlus type (11th column) 

%%%%%%%%%%%%% adam's comments here %%%%%%%%%%%%%
% The line below doesn't work for me
%%%%%%%%%%%%% adam's comments ended %%%%%%%%%%%%

%%%%%% it only works if Mean_SD_stmType is also a 4D matrix, it matches in
%%%%%% size (not at all neccessary though)

% Behav_all = horzcat(Mean_SD_blocks, Mean_SD_stmType);


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

%%%%%%%%%%%%% adam's comments here %%%%%%%%%%%%%
% For the bar graph:
% The bar graph could take as input a matrix and then it would group
% conditions automatically, according to the matrix structure. So we can 
% turn the var "mean_stmType" into a 2x2 matrix and just feed it to the bar()
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
ylabel('Mean RT (ms)');

%%%%%%%%%%%%% adam's comments ended %%%%%%%%%%%%



