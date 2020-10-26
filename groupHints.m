%% Hints for the script loading the logVar files in some loop
% None of these below is tested...
%


%% As input / basic parameters, give it (1) a path to a folder holding data
% and (2) a list of subject numbers
searchDir = '/home/stim/FG-RT/';
subjects = 2:12;


%% Find the files somehow - use "dir" perhaps
filePaths = strings(length(subjects), 1);  % preallocate
for s = subjects
    tmp = dir([searchDir, '**/sub', num2str(s), 'Log.mat']);  % search with wildcards
    %%%%%%%%%%
    % here make sure somehow that only one result was returned by "dir"
    %%%%%%%%%%
    
    % store path
    filePaths(s) = [tmp.folder, '/', tmp.name];
    
end


%% Hopefully the above block gave us a correct list of files to load - now
% we can just go through them in a loop

% First preallocate all result variables - we would like to have variables
% capable of holding all subject-level results
FGall = struct(length(subjects), 1);

% loop
for s = 1:length(subjects)
    FGall(s) = FGdata_clean(filePaths(s));
end


%% Task: try to do one anova on any set of a the results - e.g. on RT data

% first probably extract all RT data into one numeric array

% then look into "anovan" and try to come up with the right usage for our
% case: 2x2 within-subject design



