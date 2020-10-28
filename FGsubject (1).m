% get all subject files --> to later perform stats
% should look like an N dimensional struct with each layer of subject data

searchDir = '/home/lucab/Downloads/FG-RT-master/SFG_sample';
%searchDir = '/C:/Users/Luca/**/SFG_sample/';

subjects = ([2:5 101 103:105]); % right now works on only a predefined subset of subjects, 
                                % need to correct for errors when subject no. is missing
                                % (??)

%% Find the files somehow - use "dir" perhaps
filePaths = strings(length(subjects), 1);  % preallocate
for s = subjects
    searchDir; % not sure how to use this for the next line of code ("too many input arg for dir")
    SubLogFiles = dir(['**/sub', num2str(s), 'Log.mat']);
    %%%%%%%%%%
    % here make sure somehow that only one result was returned by "dir"
    %%%%%%%%%%
    if numel(SubLogFiles) > 1
        SubLogFiles(2)= [];
    end
    % deletes the second element of the structure (if there is any) to
    % avoid duplicates (probably not the best solution)
    
    % store path
    filePaths(s) = fullfile(SubLogFiles.folder, SubLogFiles.name);
    
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


for s = subjects
    FGall(s) = FGdata_clean(filePaths(s), 0);
end


