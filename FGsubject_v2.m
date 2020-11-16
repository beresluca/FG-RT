function FGall = FGsubject_v2(searchDir, subjects)
%% SFG aging study - behavioral data analysis for multiple subjects using the 'FGdata_clean' function 
%
% USAGE: FGall = FGsubject(searchDir, subjects)
%
% Function for getting multiple subject data at once, using the
% "FGdata_clean' function (see help for more info, default is no plots)
%
% Mandatory input 
%
% searchDir:             - char array, directory for subject log files
%                         ** wildcards not supported!
%                         (example: /home/usr/folder1/folder2/) 
%
% subjects:              - numeric array of subject no. 
%                         (example: [2:5 101 103:105])
%
% Output
%
% ToneCompValues:       - Numeric vector with tone component values
%
% figCoherence:         - NUmeric vector with figure coherence values  
% 
% subRT:                - 4D array with block-level RT sorted by stimulus type 
%                           [trial x block x figure x difficulty]*
%
% subAcc:               - 4D array with block-level accuracy sorted by stimulus type
%                           [trial x block x figure x difficulty]*
%
% mean_RT:              - Numeric value, overall mean of RT
%
% sd_RT:                - Numeric value, overall Standard Deviation of RT
%
% RTblockMeanSD:        - 4D array with block-level means (1st row of each dimension) 
%                           and SD of RT (2nd row of each dimension)
%                           [mean,SD x block x figure x difficulty]*
% 
% mean_stmType:         - 2x2 array with mean RTs for each stimulus type
%                           [figure x difficulty]*
% 
% sd_stmType:           - 2x2 array with SD RTs for each stimulus type
%                           [figure x difficulty]*
% 
% accuracy:             - Proportion of correct responses (%)
% 
% MeanAccuracy:         - 2x2 array with mean accuracy(%) for each stimulus type
%                           [figure x difficulty]*
% 
% MeanAccuracy_block:   - 3D array with block-level accuracy(%) sorted by stimulus type
%                           [block x figure x difficulty]*
%                          
%
%
%  *  block no. [1:10]
%     figure (1=absent, 2=present)
%     difficulty (1=easy, 2=difficult)
%

%% Check inputs

% check number of inputs
if ~ismember(nargin, 2) 
    error('Function FGsubject requires input arg "searchDir" AND "subjects"!');
end

% check for searchDir
if ~exist(searchDir, 'dir')
    error('Input arg "searchDir" is not an existing directory!');
end

% check for subjects
if ~isnumeric(subjects)
    error('Input arg "subjects" is not a valid numeric array!');
end

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


%% Go through the file paths in a loop

% preallocate struct
FGall = struct('subNumber', zeros(1,1),'ToneCompValues', zeros(1,2), 'ToneCompdiff', zeros(1,1), ...
        'figCoherence', zeros(1,1), 'subRT', zeros(20,10,2,2), 'subAcc', zeros(20,10,2,2),...
        'mean_RT', zeros(1,1), 'sd_RT', zeros(1,1), 'RTblockMeanSD', zeros(2,10,2,2),...
        'mean_stmType', zeros(2,2), 'sd_stmType', zeros(2,2), 'accuracy', zeros(1,1),...
        'hitrate_all', zeros(1,1), 'FArate_all', zeros(1,1), 'dprime_all', zeros(1,1), ...
        'hitrateEasy', zeros(1,1), 'hitrateDiff', zeros(1,1), 'FArateEasy', zeros(1,1), ...
        'FArateDiff', zeros(1,1), 'DprimeEasy', zeros(1,1), 'DprimeDiff', zeros(1,1), ...
        'RThitEasy', zeros(1,1), 'RThitDiff', zeros(1,1), 'RTFAEasy', zeros(1,1), ...
        'RTFADiff', zeros(1,1), 'MeanAccuracy', zeros(2,2), 'MeanAccuracy_block', zeros(10,2,2));

% loop through
myIds = 1:length(filePaths);
for z = myIds
    
    FGall(z) = FGdata_clean(filePaths(z), 0);
    
end

return


