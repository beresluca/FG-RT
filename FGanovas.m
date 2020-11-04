%% Define the basics

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

filePathsRe = reshape(filePaths, [length(filePaths),1]);

%% Load files into a cell array

allDataS = [];

for i = 1:length(filePathsRe)
    
    allDataS(i) = load(filePathsRe(i));  
    allData = struct2cell(allDataS);
    allData = squeeze(allData);
   
end

allTrials = length(filePathsRe)*800;

%% Get variables from logVar for all subjects

RT_all = [];
blockIdx = [];
figP = [];
isDiff = [];
subNo = [];
isOld = [];

data4anova = zeros(allTrials,6);

for k = 1:length(filePathsRe)
        
    log = allData{k,:};
    
    RT_sub          = cell2mat(log(2:end,12));
    blockIndices 	= cell2mat(log(2:end,2));
    figPresent      = cell2mat(log(2:end,7));  
    stim_difficulty = cell2mat(log(2:end,5)); 
    diffValues      = [min(unique(stim_difficulty)), max(unique(stim_difficulty))]; % getting min and max values of coherence
    isDifficult     = stim_difficulty==diffValues(2);
    subNum          = cell2mat(log(2:end,1));
    is_old          = logical(subNum > 100);
    
    RT_all = [RT_all; RT_sub];
    blockIdx = [blockIdx; blockIndices];
    figP = [figP; figPresent];
    isDiff = [isDiff; isDifficult];
    subNo = [subNo; subNum];
    isOld = [isOld; is_old];
      
    %RT_all((k-1)*800+1 : k*800, 1) = RT_sub;
    
    data4anova = horzcat(subNo, RT_all, blockIdx, figP, isDiff, isOld);  
     
end
              

%% ANOVA

[Pvalues, T, stats] = anovan(RT_all, {isOld, figP, isDiff, subNo}, 'model', 2, ...
                   'random', 4, 'varnames', {'Age', 'Figure', 'Diff', 'Sub'});           
               
% getting NaN for P values for 'isOld' and 'subNo', works without subNo as a random effect..
%
% we have repeated measures --> 'ranova' or GLMM?
%
               
disp('Done!');               



