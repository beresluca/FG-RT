% Means and StD by blocks, stimulustype, etc.

load sub2Log.mat;

RT_all = logVar(2:end,12);
RT_all = cell2mat(RT_all);
% reaction times for all blocks

avrg_all = mean(RT_all); % mean and std of reaction time for all blocks
std_all = std(RT_all);

disp(['Mean for all blocks: ', num2str(avrg_all),' STD for all blocks: ', num2str(std_all)]);


%% A version with logical indexing
% extracting mean and SD of reaction times for each block

% get block indices for all trials from logVar
blockIndices = cell2mat(logVar(2:end, 2));

% get rt for all trials from logVar
RT_all = cell2mat(logVar(2:end, 12));

% determine the block index values present in the data
blockIdxValues = unique(blockIndices);

% I want to rearrange RT data first in a matrix, where columns correspond
% to different blocks, while rows contain trial-level rt. 
% Preallocate the variable holding RT in a separate column for each block
% (we assume that there is an equal number of trials for each block)
blockRT = zeros(length(blockIndices)/length(blockIdxValues), length(blockIdxValues));  

% go through each block index value in a for loop, collect RTs for that
% block
for i = 1:length(blockIdxValues)
    % to help readability, define the current block index value
    currentBlock = blockIdxValues(i);
    
    %%%%%%%%%%%% the magical part - logical indexing  %%%%%%%%%%%%%%%
    blockRT(:, i) = RT_all(blockIndices==currentBlock);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end
    
% take a look, it should be a 80 X 10 matrix now
%disp(blockRT);

% get the mean and SD for each block
meanBlockRT = mean(blockRT, 1);
sdBlockRT = std(blockRT, 0, 1);

% display what we found
T = table(blockIdxValues, meanBlockRT', sdBlockRT', 'VariableNames', {'Block_No', 'Mean_RT', 'SD_RT'});  % arrange results in a nice table
disp([newline, 'Mean and SD of RT for each block:', newline]);
disp(T);


%% For the different stimulus / trial types, here is a hint:

figPresent = cell2mat(logVar(2:end, 7));
RT_block_figPresent = RT_all(blockIndices==i & figPresent==1);

% getting the different stimulus types (figure present or absent) 
RT_all_figPresent = RT_all(figPresent==1);
RT_all_figAbsent = RT_all(figPresent==0);

%% Figure is present

figure_blockRTm = zeros(400/length(blockIdxValues), length(blockIdxValues));

for i = 1:10  %% need a block index value for only when figures are present!! blockIndices is too long 
   
    figure_blockRTm(:, i) = RT_all(blockIndices==i & figPresent==1);
      
end

 
%disp(figure_blockRTm);


mean_FigPresentRT = mean(figure_blockRTm);
sd_FigPresentRT = std(figure_blockRTm);

meanFigPresent_all = mean(RT_all_figPresent);
sdFigPresent_all = std(RT_all_figPresent); 

disp([newline 'When Figure is present']);
disp([newline 'Mean RT: ', num2str(meanFigPresent_all)]);
disp(['  SD RT: ', num2str(sdFigPresent_all)]);

disp([newline 'Mean RT per blocks: ', num2str(mean_FigPresentRT)]);
disp(['  SD RT per blocks: ', num2str(sd_FigPresentRT)]);


%% Figure is absent

figureAbs_blockRTm = zeros(40,10);

for i = 1:10
    
    figureAbs_blockRTm(:, i) = RT_all(blockIndices==i & figPresent==0);
    
end
   
%disp(figureAbs_blockRTm);

mean_FigAbsentRT_all = mean(RT_all_figAbsent);
sd_FigAbsentRT_all = std(RT_all_figAbsent);

mean_FigAbsentRT = mean(figureAbs_blockRTm);
sd_FigAbsentRT = std(figureAbs_blockRTm);

disp([newline 'When Figure is absent: ']);
disp([newline 'Mean RT: ', num2str(mean_FigAbsentRT_all)]);
disp(['  SD RT: ', num2str(sd_FigAbsentRT_all)]); 

disp([newline 'Mean RT per blocks: ', num2str(mean_FigAbsentRT)]);
disp(['  SD RT per blocks: ', num2str(sd_FigAbsentRT)]);


%% Sorting by difficulty 

stim_difficulty = cell2mat(logVar(2:end,5));
isDifficult = (stim_difficulty)> 20; % where 20 = easy, 26 = difficult

% get RT for when stimulus is either difficult or easy
RT_all_difficult = RT_all(isDifficult==1);
RT_all_easy = RT_all(isDifficult==0); 

 
%% Difficult trials 

RT_block_difficult = zeros(40,10);

for i = 1:10
    
    RT_block_difficult(:,i) = RT_all(blockIndices==i & isDifficult==1);

end

%disp(RT_block_difficult); 

mean_difficultRT = mean(RT_block_difficult);
sd_difficultRT = std(RT_block_difficult);

disp([newline 'When trial type is difficult: ']);
disp([newline 'Mean RT per blocks: ', num2str(mean_difficultRT)]);
disp(['  SD RT per blocks: ', num2str(sd_difficultRT)]);
    
    
%% Easy trials 

RT_block_easy = zeros(40,10);

for i = 1:10
    
    RT_block_easy(:,i) = RT_all(blockIndices==i & isDifficult==0);

end

mean_easyRT = mean(RT_block_easy);
sd_easyRT = std(RT_block_easy);

disp([newline 'When trial type is easy: ']);
disp([newline 'Mean RT per blocks: ', num2str(mean_easyRT)]);
disp(['  SD RT per blocks: ', num2str(sd_easyRT)]);


%% When trial type is difficult and figure is present (??)

%RT_figPresent_Difficult = zeros()

