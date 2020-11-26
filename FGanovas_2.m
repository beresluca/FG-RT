%% Basic comparisons (ANOVAs) on the collapsed data from 'FGsubject_v2'

% convert our results struct to table (easier to handle)

searchDir = '/home/lucab/Downloads/FG-RT-master/SFG_all/';
subjects = 2:132;
FGdataTab = struct2table(FGsubject_v2(searchDir, subjects));

% FGdataTab = struct2table(FGdata);
allSubs = length(FGdataTab.subNumber);


% create primary grouping variable (young, old/good, old/impaired)
is_old = logical(FGdataTab.subNumber > 100);

hear_imp = ([103,108,109,110,111,113,115,116,119,120,121,125,127,128,129,130,132]); 

tabs = ismember(FGdataTab.subNumber, hear_imp);
isImpaired = double(tabs);

primaryGrouping = zeros(allSubs, 1);
primaryGrouping(isImpaired==0 & is_old==0) = 1;
primaryGrouping(isImpaired==0 & is_old==1) = 2;
primaryGrouping(isImpaired==1 & is_old==1) = 3; 

% number of subjects per group 
young = numel(primaryGrouping(primaryGrouping==1));
old_good = numel(primaryGrouping(primaryGrouping==2));
old_imp = numel(primaryGrouping(primaryGrouping==3));

                  
%% One-way ANOVAs for testing the age effects 
% group 1: young
% group 2: old/good
% group 3: old/impaired
%
% 'an' are P values, 'tab' contains the full anova table, 'stats' are used for
% multiple comparisons 'C'
                  
[an1, tab1, stats1] = anova1(FGdataTab.dprime_all, primaryGrouping, 'off');
C1 = multcompare(stats1);
eta1 = cell2mat(tab1(2,2))/cell2mat(tab1(4,2)); 
% getting eta squares from anova output
% SS_effect / SS_total

[an2, tab2, stats2] = anova1(FGdataTab.hitrate_all, primaryGrouping, 'off');
C2 = multcompare(stats2);
eta2 = cell2mat(tab2(2,2))/cell2mat(tab2(4,2));

[an3, tab3, stats3] = anova1(FGdataTab.FArate_all, primaryGrouping, 'off');
C3 = multcompare(stats3);
eta3 = cell2mat(tab3(2,2))/cell2mat(tab3(4,2));

[an4, tab4, stats4] = anova1(FGdataTab.accuracy, primaryGrouping, 'off');
C4 = multcompare(stats4);
eta4 = cell2mat(tab4(2,2))/cell2mat(tab4(4,2));

[an5, tab5, stats5] = anova1(FGdataTab.mean_RT, primaryGrouping, 'off');
C5 = multcompare(stats5);
eta5 = cell2mat(tab5(2,2))/cell2mat(tab5(4,2));

[an6, tab6, stats6] = anova1(FGdataTab.ToneCompdiff, primaryGrouping, 'off');
C6 = multcompare(stats6);                  
eta6 = cell2mat(tab6(2,2))/cell2mat(tab6(4,2));

[an7, tab7, stats7] = anova1(FGdataTab.figCoherence, primaryGrouping, 'off');
C7 = multcompare(stats7);  
eta7 = cell2mat(tab7(2,2))/cell2mat(tab7(4,2));
 

%% Paired T-tests for testing the stimulus effect (easy/difficult)
% 'H' returns logical values for significance, 'Pttest' are P values, 'ci'
% returns confidence intervals, Tstats contains test statistic value, df,
% sd

% on accuracy measures
[H1, Pttest1, ci1, Tstats1] = ttest(FGdataTab.DprimeEasy, FGdataTab.DprimeDiff); 
cohenD1 = computeCohen_d(FGdataTab.DprimeEasy, FGdataTab.DprimeDiff, 'paired');

[H2, Pttest2, ci2, Tstats2] = ttest(FGdataTab.hitrateEasy, FGdataTab.hitrateDiff); 
cohenD2 = computeCohen_d(FGdataTab.hitrateEasy, FGdataTab.hitrateDiff, 'paired');

[H3, Pttest3, ci3, Tstats3] = ttest(FGdataTab.FArateEasy, FGdataTab.FArateDiff);
cohenD3 = computeCohen_d(FGdataTab.FArateEasy, FGdataTab.FArateDiff, 'paired');

[H4, Pttest4, ci4, Tstats4] = ttest(FGdataTab.accuracy_easy, FGdataTab.accuracy_diff);
cohenD4 = computeCohen_d(FGdataTab.accuracy_easy, FGdataTab.accuracy_diff, 'paired');

% on RT
[H5, Pttest5, ci5, Tstats5] = ttest(FGdataTab.RTeasy, FGdataTab.RTdiff);
cohenD5 = computeCohen_d( FGdataTab.RTeasy, FGdataTab.RTdiff, 'paired');

[H6, Pttest6, ci6, Tstats6] = ttest(FGdataTab.RThitEasy, FGdataTab.RThitDiff);
cohenD6 = computeCohen_d(FGdataTab.RThitEasy, FGdataTab.RThitDiff, 'paired');

[H7, Pttest7, ci7, Tstats7] = ttest(FGdataTab.RTFAEasy, FGdataTab.RTFADiff);
cohenD7 = computeCohen_d(FGdataTab.RTFAEasy, FGdataTab.RTFADiff, 'paired');
                  

%% Cohen's d

% Cohen's d = (M2 - M1) ⁄ SDpooled            
% where: SDpooled = √(((SD1)2 + (SD2)2) ⁄ 2)
%
% used function computeCohen_d

%% Testing age effects (3 groups) on digit span


% forward, backward digit span + sum from excel file
% subject 1 excluded!!

digitspan = xlsread('20201111_data_subject_descriptive_behav.xlsx', 1, 'H3:J54');
forward_ds = digitspan(1:end,1);
backward_ds = digitspan(1:end,2);

% one-way anovas
[an8, tab8, stats8] = anova1(forward_ds, primaryGrouping, 'off');
C8 = multcompare(stats8);
eta8 = cell2mat(tab8(2,2))/cell2mat(tab8(4,2));

[an9, tab9, stats9] = anova1(backward_ds, primaryGrouping, 'off');
C9 = multcompare(stats9);
eta9 = cell2mat(tab9(2,2))/cell2mat(tab9(4,2));

% t test comparing forward and backward digit span
[H8, Pttest8, ci8, Tstats8] = ttest(forward_ds, backward_ds);
cohenD8 = computeCohen_d(forward_ds, backward_ds, 'paired');


%% Stroop effect
% RT congruent (correct) - RT incongruent (correct)

stroop_data = xlsread('20201111_data_subject_descriptive_behav.xlsx', 1, 'K3:P54');
stroop_effect = stroop_data(1:end,1) - stroop_data(1:end,4);

[an10, tab10, stats10] = anova1(stroop_effect, primaryGrouping, 'off');
C10 = multcompare(stats10);
eta10 = cell2mat(tab10(2,2))/cell2mat(tab10(4,2));

stroop_tmp = xlsread('20201111_data_subject_descriptive_behav.xlsx', 1, 'Q3:V54');
stroop_acc = stroop_tmp(1:end,1) - stroop_tmp(1:end,4);

[an11, tab11, stats11] = anova1(stroop_acc, primaryGrouping, 'off');
C11 = multcompare(stats11);
eta11 = cell2mat(tab11(2,2))/cell2mat(tab11(4,2));



