% Means and StD by blocks, stimulustype, etc.

load sub2Log.mat;

data_all = logVar(2:801,2:12);
% just the first 12 columns without labels

RT_all = data_all(:,11);
RT_all = cell2mat(RT_all);
% reaction times for all blocks

avrg_all = mean(RT_all); % mean and std of reaction time for all blocks
std_all = std(RT_all);

disp(['Mean for all blocks: ', num2str(avrg_all), ' STD for all blocks: ', num2str(std_all)])


% sum = 0;
% count = 0;
% numberofTrials = 
% 
% for i = 1:size(data_all)
%        
%    if data_all{i,1}== 1
%        disp(num2str(data_all{i,11}))
%        sum = sum + data_all{i,11};
%        count = count + 1;
%    end
%   
% end
% 
% disp(['avg: ', num2str(sum/count), ' ', num2str(sum), ' ', num2str(count)]);



% data_all = logVar(2:801,2:12);
% sum = data_all{1,11};
% count = 1;
% currentBlock = data_all{1,1}; %



% Look into logical indexing - could it be used instead of a for loop here?
for currentBlock = 1:10
    
    for i = 2:size(data_all)  % size(data_all) returns a 2-element vector?
        
        if data_all{i,1} == currentBlock  % the role of the if-else is unclear
            sum = sum + data_all{i,11};  % define the var first + check for built-ins whenever using simple var names
            count = count + 1;  % check for built-ins whenever using simple var names
        else
            disp(['block number: ', num2str(currentBlock), ' RT mean: ', num2str(sum/count), ' STD: ', num2str(std(sum/count))]);
            currentBlock = data_all{i, 1};
            sum = data_all{i, 11};
            count = 1;
        end
        
    end
    
end
disp(['block number: ', num2str(currentBlock), ' RT mean: ', num2str(sum/count), ' STD: ', num2str(std(sum/count))]); 



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
disp(blockRT);

% get the mean and SD for each block
meanBlockRT = mean(blockRT, 1);
sdBlockRT = std(blockRT, 0, 1);

% display what we found
T = table(blockIdxValues, meanBlockRT', sdBlockRT', 'VariableNames', {'Block_No', 'Mean_RT', 'SD_RT'});  % arrange results in a nice table
disp([newline, 'Mean and SD of RT for each block:', newline]);
disp(T);





