% get all subject files --> to later perform stats
% should look like an N dimensional struct with each layer of subject data

% searchDir = '/home/lucab/Downloads/FG-RT-master/SFG_sample/';
searchDir = '/home/stim/FG-RT/sampleData/';  % adam's home pc path for this
%searchDir = '/C:/Users/Luca/**/SFG_sample/';

% subjects = [2:5 101 103:105]; % right now works on only a predefined subset of subjects, 
%                                 % need to correct for errors when subject no. is missing
%                                 % (??)
% What do you mean by "when subject no. is missing"?

subjects = [3, 4];  % for sampleData in repo


%% Find the files somehow - use "dir" perhaps

filePaths = strings(length(subjects), 1);  % preallocate
% a counter is used for storing paths in "filePaths" in the loop
counter = 1;
for s = subjects
%     searchDir; % not sure how to use this for the next line of code ("too many input arg for dir")
%     SubLogFiles = dir(['**/sub', num2str(s), 'Log.mat']);

    SubLogFiles = dir([searchDir, '**/sub', num2str(s), 'Log.mat']);  % this version works for me - adam
    
    %%%%%%%%%%
    % here make sure somehow that only one result was returned by "dir"
    %%%%%%%%%%
%     if numel(SubLogFiles) > 1
%         SubLogFiles(2)= [];
%     end
    % deletes the second element of the structure (if there is any) to
    % avoid duplicates (probably not the best solution)
    
    % Good solution, but we could just make it throw an error if there are
    % more than one file. Let the user handle the problem.
    if numel(SubLogFiles) > 1
        error(['Multiple files found for subject ', num2str(s), '! Aborting as we are better safe then sorry!']);
    end    
    
    % store path
    filePaths(counter) = fullfile(SubLogFiles.folder, SubLogFiles.name);
    counter = counter+1;
    
end


%% Hopefully the above block gave us a correct list of files to load - now
% we can just go through them in a loop

% First preallocate all result variables - we would like to have variables
% capable of holding all subject-level results
FGall = struct('ToneCompValues', zeros(1,2), 'figCoherence', zeros(1,2),...
        'subRT', zeros(20,10,2,2), 'subAcc', zeros(20,10,2,2),...
        'mean_RT', zeros(1,1), 'sd_RT', zeros(1,1), 'RTblockMeanSD', zeros(2,10,2,2),...
        'mean_stmType', zeros(2,2), 'sd_stmType', zeros(2,2), 'accuracy', zeros(1,1),...
        'MeanAccuracy', zeros(2,2), 'MeanAccuracy_block', zeros(10,2,2));

for s = 1:length(subjects)
    FGall(s) = FGdata_clean(filePaths(s), 0);
end




