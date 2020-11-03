% 
% tmp11 = nan(47, 10);
% for i = 1:47
%     tmp11(i,:) = FGall(i).RTblockMeanSD(1,:,1,1);
% end
% 
% 
% 
% % [P,ANOVATAB,STATS] = anova1(tmp11);
% % [COMPARISON,MEANS,H] = multcompare(STATS);
% 
% %P = anovan(FGall(1).subRT
% 
% %[P, STATS] = anovan(FGall(1).subRT(:,:,1,1), FGall(1).subAcc(:,:,1,1));
% 
% young = nan(19,1);
% for k = 1:19
%     young(k,:) = FGall(k).mean_RT;
% end
% 
% old = nan(28,1);
% for j = 20:47
%     old(j) = FGall(j).mean_RT;
% end
% 
% old = old(20:47);


searchDir = '/home/lucab/Downloads/FG-RT-master/SFG_all/';
subjects = 2:12;

%% Find the files in given search directory

filePaths = strings(1, 1);  % preallocate
counter = 1;

for s = subjects
    
    % get subject log files
    SubLogFiles = dir([searchDir, '**/sub', num2str(s), 'Log.mat']);
  
    % check for duplicates
    if numel(SubLogFiles) > 1
        error(['Multiple files found for subject ', num2str(s), '! Aborting as we are better safe than sorry!']);
    end    

    % store path
    if ~isempty(SubLogFiles)
        filePaths(counter) = fullfile(SubLogFiles.folder, SubLogFiles.name);
        counter = counter + 1;
    end    
end

filePathsRe = reshape(filePaths, [length(filePaths),1]);

%allDataS = struct([]);
%allDataS = struct('logVar1', cell(1,1), 'logVar2', cell(1,1)); 

for i = 1:length(filePathsRe)
    
    allDataS(i) = load(filePathsRe(i));  
    allData = struct2cell(allDataS);
    allData = squeeze(allData);
   
end

% get variables from logVar 

RT_sub = zeros(800,1);
%RT_all = zeros(8000,1);
RT_all = [];
blockIdx = [];
figP = [];
isDiff = [];
subNo = [];

data4anova = zeros(8000,5);

for k = 1:10
        
    log = allData{k,:};
    
    RT_sub          = cell2mat(log(2:end,12));
    blockIndices 	= cell2mat(log(2:end,2));
    figPresent      = cell2mat(log(2:end,7));  
    stim_difficulty = cell2mat(log(2:end,5)); 
    diffValues      = [min(unique(stim_difficulty)), max(unique(stim_difficulty))]; % getting min and max values of coherence
    isDifficult     = stim_difficulty==diffValues(2);
    subNum          = cell2mat(log(2:end,1));
    
    %RT_all = vertcat(RT_sub);
    RT_all = [RT_all; RT_sub];
    blockIdx = [blockIdx; blockIndices];
    figP = [figP; figPresent];
    isDiff = [isDiff; isDifficult];
    subNo = [subNo; subNum];
    
    %RT_all((k-1)*800+1 : k*800, 1) = RT_sub;
    
    data4anova = horzcat(subNo, RT_all, blockIdx, figP, isDiff);
    
     
end









