
%% Audiometric thresholds
% legyen külön minden frekvencián több szempontos anova --> age effect,
% jobb-bal fül, 

% searchDir = '/home/lucab/Downloads/FG-RT-master/SFG_all/';
% subjects = 2:132;
% FGdataTab = struct2table(FGsubject_v2(searchDir, subjects));

audio_all = xlsread('20201111_data_subject_descriptive_behav.xlsx', 1, 'X3:AK54');
subs = 52;

audioValues = [];
for i = 1:subs
   
    tmp = audio_all(i,:);  
    audioValues = [audioValues; reshape(tmp, 14,1)];
    
end

subNumber = FGdataTab.subNumber;
sub_num_aud = repelem(subNumber, 14);

earSide = strings(14,1);
earSide(1:8,1) = 'left';
earSide(8:14,1) = 'right';

ear_side = repmat(earSide,subs,1);

freq_values = ["250", "500", '1000', '2000', '4000', '6000', '8000'];
Q = reshape(freq_values, 7,1);
freqValues = repmat(Q,(subs*2),1);

%% get primary grouping variable 

allSubs = length(sub_num_aud);

% create primary grouping variable (young, old/good, old/impaired)
is_old = logical(sub_num_aud > 100);

hear_imp = ([103,108,109,110,111,113,115,116,119,120,121,125,127,128,129,130,132]); 

tabs = ismember(sub_num_aud, hear_imp);
isImpaired = double(tabs);

primaryGrouping = zeros(allSubs, 1);
primaryGrouping(isImpaired==0 & is_old==0) = 1;
primaryGrouping(isImpaired==0 & is_old==1) = 2;
primaryGrouping(isImpaired==1 & is_old==1) = 3; 


%% ANOVA on audimetrics

% [audP, audTab, audStats] = anovan(audioValues, {sub_num_aud, primaryGrouping},...
%                           'model', 1, 'random', 1, 'display', 0, 'varnames', {'Subject', ...
%                            'Primary Grouping'});
                       
[audP, audTab, audStats] = anovan(audioValues, {primaryGrouping, freqValues,...
                           sub_num_aud, ear_side}, 'model', 2, 'random', 3, 'display', 0,...
                           'nested', [0 0 0 0; 0 0 0 0; 1 0 0 0; 0 0 0 0], ...  
                           'varnames', {'Group', 'Frequency', 'Subject', 'Ear side'});                       
                       
             
                 
                        
                
                        
                        
