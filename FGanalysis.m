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
for i = 2:size(data_all)
    if data_all{i,1} == currentBlock
        sum = sum + data_all{i,11};
        count = count + 1;
    else
        disp(['block number: ', num2str(currentBlock), ' RT mean: ', num2str(sum/count), ' STD: ', num2str(std(sum/count))]);
        currentBlock = data_all{i, 1};
        sum = data_all{i, 11};
        count = 1;
    end
end
disp(['block number: ', num2str(currentBlock), ' RT mean: ', num2str(sum/count), ' STD: ', num2str(std(sum/count))]); 


