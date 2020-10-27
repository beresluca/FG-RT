% get all subject files --> to later perform stats
% should look like an N dimensional struct with each layer of subject data

% tmp = FGdata_clean('sub5Log.mat', 0);
% tmp(2) = tmp(1);
% size(tmp) 
% ans = 
%       1    2
%
%  tmp(2).subRT(:,1,1,1) --> could be indexed like this 

subjects = 2:5;

SubLogFiles = dir('**/sub*Log.mat');
m = (struct2cell(SubLogFiles));
filePaths = m(1,:);
filePaths_reshaped = reshape(filePaths, [numel(filePaths), 1]);
filePaths_reshaped = string(filePaths_reshaped);


for i = 1 : length(SubLogFiles)
    
    baseFileName = SubLogFiles(i).name;
    fullFileName = fullfile(SubLogFiles(i).folder, baseFileName);
    FGdata_clean(baseFileName);
    
end

