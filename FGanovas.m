%% Define the basics

% clear workspace variables
clear;

searchDir = '/home/lucab/Downloads/FG-RT-master/SFG_all/';
subjects = 2:132;

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

% reshape so it looks nicer
filePathsRe = reshape(filePaths, [length(filePaths),1]);

%% Load subject log files into a cell array

% cannot preallocate (?)
%allDataS = [];

for i = 1:length(filePathsRe)
    
    allDataS(i) = load(filePathsRe(i));  
    allData = struct2cell(allDataS);
    allData = squeeze(allData);
   
end

allTrials = length(filePathsRe)*800;

%% Get variables from logVar for all subjects

% preallocate everything, we want long vectors for ANOVAs with trial level
% data for all subjects

RT_all = [];
blockIdx = [];
figP = [];
isDiff = [];
subNo = [];
isOld = [];
figCoh = [];
toneCompDiff = [];
hitMiss = [];
Accuracy = [];
trialNo = [];
primaryGrouping = zeros(allTrials, 1);

% contains subject numbers with impaired hearing
hear_imp = ([103,108,109,110,111,113,115,116,119,120,121,125,127,128,129,130,132]); 
isImpaired = [];

hit_miss = strings(800,1);

for k = 1:length(filePathsRe)
        
        log = allData{k,:}; % go through the filepaths, get the variables needed

        RT_sub          = cell2mat(log(2:end,12));
        blockIndices 	= cell2mat(log(2:end,2));
        figPresent      = cell2mat(log(2:end,7));  
        stim_difficulty = cell2mat(log(2:end,5)); 
        diffValues      = [min(unique(stim_difficulty)), max(unique(stim_difficulty))]; % getting min and max values of coherence
        isDifficult     = stim_difficulty==diffValues(2);
        toneCompdiff    = stim_difficulty - diffValues(1); % get zeros and tone comp difference values for each trial
        subNum          = cell2mat(log(2:end,1));
        accuracy        = cell2mat(log(2:end,10));
        is_old          = logical(subNum > 100);
        fig_coh         = cell2mat(log(2:end,6));
        buttonResp      = cell2mat(log(2:end,11));
        trialNum        = cell2mat(log(2:end,3));

        % 1 vector containing hit/miss/FA/CR values
        hit_miss(figPresent==1 & buttonResp==1) = 'HIT';
        hit_miss(figPresent==1 & buttonResp==0) = 'MISS';
        hit_miss(figPresent==0 & buttonResp==0) = 'CR';
        hit_miss(figPresent==0 & buttonResp==1) = 'FA';
        

        % concatenate subject level data
        RT_all       = [RT_all; RT_sub];
        blockIdx     = [blockIdx; blockIndices];
        figP         = [figP; figPresent];
        isDiff       = [isDiff; isDifficult];
        subNo        = [subNo; subNum];
        isOld        = [isOld; is_old];
        figCoh       = [figCoh; fig_coh];
        toneCompDiff = [toneCompdiff; toneCompDiff];
        hitMiss      = [hitMiss; hit_miss];
        Accuracy     = [Accuracy; accuracy];
        trialNo      = [trialNo; trialNum];

        % something like this for grouping by hearing (?)        
        tmp = ismember(subNo, hear_imp);
        isImpaired = double(tmp);
        
        % grouping variable for the 3 groups 
        % 1 = young, 2 = old/good hearing, 3 = old/impaired hearing
        primaryGrouping(isImpaired==0 & isOld==0) = 1;
        primaryGrouping(isImpaired==0 & isOld==1) = 2;
        primaryGrouping(isImpaired==1 & isOld==1) = 3;    
   
end

%primaryGroupingRe = reshape(primaryGrouping, [allTrials,1]);

            
%% (1) ANOVA on accuracy for 3 groups (young/old-impaired/old-good)

% one-way anova 
[P0, T0, stats0] = anova1(Accuracy, primaryGrouping);
% do we need trial level for this analysis or should I use the collapsed
% data (from FGsubject_v2)?

comp1 = multcompare(stats0, 'ctype', 'bonferroni');  

[P1, T1, stats1] = anovan(Accuracy, {isImpaired, isOld}, 'model', 1, ...
                   'display', 0, 'varnames', {'Hearing', 'Age'});             
%                
%save('anova1.csv', 'T1');
               
%% (2) ANOVA on RT with subject number as a random factor

% without block index
[P2, T2, stats2] = anovan(RT_all, {isDiff, figP, subNo}, 'model', 2, ...
                 'random', 3, 'display', 0, 'varnames', {'Diff', 'Figure', 'Sub'});   
              
% saving 
%save('anova2.csv', 'T2'); 

% with block index              
[P3, T3, stats3] = anovan(RT_all, {isDiff, figP, subNo, blockIdx}, 'model', 2, ...
                   'random', 3, 'display', 0, 'varnames', {'Diff', 'Figure', 'Sub', 'Block'}); 
               
%save('anova3.csv', 'T3');               
               
%              
% # and NaN values are returned because there are missing factor 
% combinations and the model has higher-order terms, check crosstab below
%
%
% [tbl,p,factorvals] = crosstab(figP, isDiff, blockIdx);
%



%% (2) ANOVA on accuracy, added tone component difference as a continuous factor ??

[P4, T4, stats4] = anovan(Accuracy, {toneCompDiff}, 'model', 1, 'continuous', 1, ...
                   'display', 0, 'varnames', {'Tone component'});

%[comp, Means] = multcompare(stats3);

%save('anova4.csv', 'T4');


%% (3) ANOVA on hitrate, FA rate
 
% grouping (young, old-impaired, old-good) on hitrate, FA rate ???

%[P5, T5, stats5] = anovan(hitMiss, {primaryGrouping}, 'model', 1, ...
%                   'display', 0, 'varnames', {'primary grouping'});

%save('anova5.csv', 'T5');






disp('Done, saved!');               



%% info

%%%%% missing: 
% 3,19,101,102,122,124 --> solved!

%%%%% hearing impaired %%%%%
% 103,108,109,110,111,113,115,116,119,120,121,125,127,128,129,130,132 

%%%%% hearing good %%%%%
% 101,104,105,106,107,112,114,117,118,123,124,126,131




