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
RT_all_figPresent = RT_all(figPresent==1);
RT_all_figAbsent = RT_all(figPresent==0);

figure_blockRTm = zeros(400/length(blockIdxValues), length(blockIdxValues));

for i = 1:10%% need a block index value for only when figures are present!! blockIndices is too long 
   figure_blockRTm(:, i) = RT_all(blockIndices==i & figPresent==1);
    
end


% for i = 1:length(blockIdxValues)
%     % to help readability, define the current block index value
%     currentBlock = blockIdxValues(i);
%     
%     %%%%%%%%%%%% the magical part - logical indexing  %%%%%%%%%%%%%%%
%     figure_blockRTm(:, i) = RT_all_figPresent(blockIndices==currentBlock);
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
% end
 
disp(figure_blockRTm);


meanFigPresent_block1 = mean(RT_block1_figPresent);
sdFigPresent_block1 = std(RT_block1_figPresent);
meanFigPresent_all = mean(RT_all_figPresent);

disp(['Mean of all RT when figure is present: ', num2str(meanFigPresent_all)]);
disp(['Mean of RT when figure is present - block 1: ', num2str(meanFigPresent_block1)]);
disp(['SD of RT when figure is present - block 1: ', num2str(sdFigPresent_block1)]);







