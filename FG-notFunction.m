%% Find the files in given search directory
searchDir = '/home/lucab/Downloads/FG-RT-master/SFG_all/';
subjects = 2:132;

filePaths = strings(length(subjects), 1);  % preallocate
counter = 1;

for s = subjects
    
    % get subject log files
    SubLogFiles = dir([searchDir, '**/sub', num2str(s), 'Log.mat']);
%     
    %temp = SubLogFiles.name;
    if isempty(SubLogFiles)
        continue
    end
    
    % check for duplicates
    if numel(SubLogFiles) > 1
        error(['Multiple files found for subject ', num2str(s), '! Aborting as we are better safe than sorry!']);
    end    

    % store path
    filePaths(counter) = fullfile(SubLogFiles.folder, SubLogFiles.name);
    counter = counter + 1;
    
end

%% Go through the file paths in a loop

% preallocate struct
FGall = struct('subNumber', zeros(1,1),'ToneCompValues', zeros(1,2), ...
        'figCoherence', zeros(1,2), 'subRT', zeros(20,10,2,2), 'subAcc', zeros(20,10,2,2),...
        'mean_RT', zeros(1,1), 'sd_RT', zeros(1,1), 'RTblockMeanSD', zeros(2,10,2,2),...
        'mean_stmType', zeros(2,2), 'sd_stmType', zeros(2,2), 'accuracy', zeros(1,1),...
        'MeanAccuracy', zeros(2,2), 'MeanAccuracy_block', zeros(10,2,2));

% loop through
for s = 1:length(subjects)
    
    FGall(s) = FGdata_clean(filePaths(s), 0);
    
end
