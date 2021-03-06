function FGoutput = FGdata_clean(filename, plottingFlag)
%% Individual-level behavioral data analysis for SFG aging study
%
% USAGE: FGoutput = FGdata_clean(filename, plottingFlag)
%
% Function for getting all behavioral data (means and SDs for RT, accuracy)
% from a given subject log file
%
% Mandatory input:
% filename              - Char array, path of subject-level behavioral log file 
%                          (usually in the form "sub*Log.mat" where * = subject no.).
%
% Optional input:
% plottingFlag          - Numeric or logical value, one of [0 1]. Flag for plotting
%                          the results (0 means no plots, 1 means plots for RT and
%                           % Correct response). Defaults to 1. 
%
% Outputs:
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
if ~ismember(nargin, [1 2]) 
    error('Function FGdata_clean requires input arg "filename" while input arg "plottingFlag" is optional!');
end
% check mandatory input
if ~exist(filename, 'file')
    error('Input arg "filename" is not a valid file path!');
end
% check optional input
if nargin == 1
    plottingFlag = 1;
elseif ~ismember(plottingFlag, [0 1])
    error('Optional input arg "plottingFlag" should be one of [0 1] or logical!');
end


%% (1) Loading log file, extracting variables of interest

% find the input file
load(filename)

% get variables from logVar
RT_all          = cell2mat(logVar(2:end,12));
blockIndices 	= cell2mat(logVar(2:end, 2));
figPresent      = cell2mat(logVar(2:end, 7));  
stim_difficulty = cell2mat(logVar(2:end,5)); 
diffValues      = [min(unique(stim_difficulty)), max(unique(stim_difficulty))]; % getting min and max values of coherence
isDifficult     = stim_difficulty==diffValues(2); 
accuracy        = cell2mat(logVar(2:end,10));
figCoherence    = max(unique(cell2mat(logVar(2:end,6))));
toneCompdiff    = diffValues(2)-diffValues(1);
subNum          = cell2mat(logVar(2,1));
buttonResp      = cell2mat(logVar(2:end,11));


%% (2) sort RTs into categories, store it in output variable

% results array containing RT data
% - per blocks
% - per stimulus type (figure present/absent, easy/difficult)

subRT = nan(20, 10, 2, 2); 

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


subRTtemp = zeros(400,2);

for diff = 0:1
   subRTtemp(:, diff+1) = RT_all(isDifficult==diff); 
end

RTeasy = mean(subRTtemp(:,1), 'omitnan');
RTdiff = mean(subRTtemp(:,2), 'omitnan');



%% (4) Accuracy data 

% overall accuracy (%)
Num_acc = numel(accuracy(accuracy==1)); % number of accurate trials
proportion_acc = Num_acc/800;

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

% means for easy/difficult
acc_easy = mean(subAccReshaped(:,:,1), 'omitnan');
accuracy_easy = mean(acc_easy);
acc_diff = mean(subAccReshaped(:,:,2), 'omitnan');
accuracy_diff = mean(acc_diff);


%% HITrate FArate

hit_miss = strings(800,1);

hit_miss(figPresent==1 & buttonResp==1) = 'HIT';
hit_miss(figPresent==1 & buttonResp==0) = 'MISS';
hit_miss(figPresent==0 & buttonResp==0) = 'CR';
hit_miss(figPresent==0 & buttonResp==1) = 'FA';

hitrate    = sum(hit_miss == 'HIT') / 400; % fig is present on 50% of trials, hit is calculated on 50% as well
missrate   = sum(hit_miss == 'MISS') / 400;
FArate     = sum(hit_miss == 'FA') / 400;
CRrate     = sum(hit_miss == 'CR') / 400;

dprime = hitrate-FArate;

hits = strings(400,2);
for diff = 0:1
   
    hits(:, diff+1) = hit_miss(isDifficult == diff);
    
end

hitrateEasy = sum(hits(:,1) == 'HIT') / 200; % easy/diff is also 50-50% !
hitrateDiff = sum(hits(:,2) == 'HIT') / 200;
FArateEasy = sum(hits(:,1) == 'FA') / 200;
FArateDiff = sum(hits(:,2) == 'FA') / 200;

Hit_stmType = vertcat(hitrateEasy, hitrateDiff);
FA_stmType = vertcat(FArateEasy, FArateDiff);


DprimeEasy = hitrateEasy - FArateEasy;
DprimeDiff = hitrateDiff - FArateDiff;


%% RT means grouped by HIT / FA and difficulty

subRTdup = repmat(subRTreshaped,1);
subRTdup(buttonResp==0) = nan;

RThitEasy = mean(subRTdup(:,2,1), 'omitnan');
RThitDiff = mean(subRTdup(:,2,2), 'omitnan');
RTFAEasy = mean(subRTdup(:,1,1), 'omitnan');
RTFADiff = mean(subRTdup(:,1,2), 'omitnan');

RThit_stmType = vertcat(RThitEasy, RThitDiff);
RTFA_stmType =  vertcat(RTFAEasy, RTFADiff);


% disp([newline num2str(RThitEasy), newline num2str(RThitDiff), ...
%     newline num2str(RTFAEasy), newline num2str(RTFADiff)]);



%% (5) Plots

if plottingFlag

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

    tmpData = squeeze(mean_stmType); tmpData = tmpData'; % squeeze and transpose the data so that we group primarily by easy/difficult categories
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
    
end


%% Output, return

SQMeanAccuracy_block = squeeze(MeanAccuracy_block);
SQmean_stmType = squeeze(mean_stmType);
SQsd_stmType = squeeze(sd_stmType);
SQMeanAccuracy = squeeze(MeanAccuracy);

FGoutput = struct('subNumber', {subNum}, 'ToneCompValues', {diffValues}, 'ToneCompdiff', {toneCompdiff}, ...
                    'figCoherence', {figCoherence}, 'subRT', {subRT}, 'subAcc', {subAcc}, 'mean_RT', {mean_RT},...
                    'sd_RT', {sd_RT}, 'RTblockMeanSD', {RTblockMeanSD}, 'RTeasy', {RTeasy}, 'RTdiff', {RTdiff}, ...
                    'mean_stmType', {SQmean_stmType}, 'sd_stmType', {SQsd_stmType}, 'accuracy', {proportion_acc}, ...
                    'hitrate_all', {hitrate}, 'FArate_all', {FArate}, 'dprime_all', {dprime}, ...
                    'hitrateEasy', {hitrateEasy}, 'hitrateDiff', {hitrateDiff}, 'FArateEasy', {FArateEasy}, ...
                    'FArateDiff', {FArateDiff}, 'DprimeEasy', {DprimeEasy}, 'DprimeDiff', {DprimeDiff}, ...
                    'RThitEasy', {RThitEasy}, 'RThitDiff', {RThitDiff}, 'RTFAEasy', {RTFAEasy}, 'RTFADiff', {RTFADiff}, ... 
                    'MeanAccuracy', {SQMeanAccuracy}, 'MeanAccuracy_block', {SQMeanAccuracy_block},...
                    'accuracy_easy', {accuracy_easy}, 'accuracy_diff', {accuracy_diff});

disp([newline 'Done!']);


return



