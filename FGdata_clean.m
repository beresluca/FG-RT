%% %% %% %% SFG aging study - behavioral data analysis %% %% %% %%


%% (1) Loading log file, extracting variables of interest

dir /home/lucab/Downloads/FG-RT-master/sampleData

load('sub2Log.mat');

RT_all          = cell2mat(logVar(2:end,12));
blockIndices 	= cell2mat(logVar(2:end, 2));
figPresent      = cell2mat(logVar(2:end, 7));  
stim_difficulty = cell2mat(logVar(2:end,5)); 
diffValues      = [min(unique(stim_difficulty)), max(unique(stim_difficulty))]; % getting min and max values of coherence
isDifficult     = stim_difficulty==diffValues(2); 
accuracy        = logical(cell2mat(logVar(2:end,10)));

%% (2) sort RTs into categories, store it in output variable

% results array containing RT data
% - per blocks
% - per stimulus type (figure present/absent, easy/difficult)

subRT = nan(20, 10, 2, 2); 
% 3rd and 4th dimension representing figure presence (1=absent, 2=present)
% and difficulty (1=easy, 2=difficult)

for blockIdx = 1:10
    
    for fig = 0:1
        
        for diff = 0:1
            
            subRT(:, blockIdx, fig+1, diff+1) = RT_all(blockIndices==blockIdx & figPresent==fig & isDifficult==diff);
            
        end
    end   
end

%% (3) Reporting descriptve stats for RT

% get overall mean and SD for RT (all blocks combined 1x1)
mean_RT = mean(subRT(:), 'omitnan'); % omit NAN values
sd_RT = std(subRT(:), 'omitnan');

% get mean RT per blocks, stimulus type (4D)
RTblockMean = mean(subRT, 1, 'omitnan');  
RTblockSD = std(subRT, 0, 1, 'omitnan');  

% first row: means, second row: SD (4D)
RTblockMeanSD = vertcat(RTblockMean, RTblockSD);

% block level removed to check stats only per stimulus type (3D)
% get mean and SD for RT per condition
subRTreshaped = reshape(subRT, [200, 2, 2]);  
mean_stmType = mean(subRTreshaped, 'omitnan');  
sd_stmType = std(subRTreshaped, 'omitnan');


%% (4) Accuracy data 

% overall accuracy (%)
Num_acc = numel(accuracy(accuracy==1)); % number of accurate trials
proportion_acc = Num_acc/800*100;

% 4D results array containing accuracy 
% - per blocks
% - per stimulus type (figure present/absent, easy/difficult)

subAcc = nan(20, 10, 2, 2);

for blockIdx = 1:10
    
    for fig = 0:1
        
        for diff = 0:1
            
            subAcc(:, blockIdx, fig+1, diff+1) = accuracy(blockIndices==blockIdx & figPresent==fig & isDifficult==diff);
            
        end
    end   
end

% get means (per blocks & stimulus type)
MeanAccuracy_block = mean(subAcc, 'omitnan');

% blocks combined
subAccReshaped = reshape(subAcc, [200,2,2]);
MeanAccuracy = mean(subAccReshaped, 'omitnan');


%% (5) Plots

% 1) line plot for mean RTs per blocks and stimulus type

figure(1)

hold on
for fig = 0:1
    
    for diff = 0:1
        
        plot(RTblockMean(:,:,fig+1,diff+1), 'o-');  
        
    end
end

% set parameters
legend('fig absent / easy', 'figure absent / diff', 'figure present / easy', 'figure present / diff');
xlabel('Block no.');
ylabel('Mean RT (ms)');


% 2) bar plot for mean RTs per stimulus type

figure(2);

tmpData = squeeze(mean_stmType); tmpData = tmpData'; %squeeze and transpose the data so that we group primarily by easy/difficult categories
b = bar(tmpData);
set(gca,'XTickLabel', {'Easy', 'Difficult'}); % set parameters
legend('Figure Absent', 'Figure Present');
xlabel('Stimulus types');
ylabel('Mean RT (ms)');


% 3) line plot for mean accuracy per blocks

figure(3);

hold on
for fig = 0:1
    
    for diff = 0:1
        
        plot(MeanAccuracy_block(:,:,fig+1,diff+1), 'o-');
        
    end
end
        
legend('fig absent / easy', 'figure absent / diff', 'figure present / easy', 'figure present / diff');
xlabel('Block no.');
ylabel('Correct responses (%)');    


% bar plot for mean accuracy per stimulus type
        
figure(4);

tmpData2 = squeeze(MeanAccuracy); tmpData2 = tmpData2';
b2 = bar(tmpData2);
set(gca,'XTickLabel', {'Easy', 'Difficult'});
legend('Figure Absent', 'Figure Present');
xlabel('Stimulus types');
ylabel('Correct responses (%)');
        
        
disp('Done!');



