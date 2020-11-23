%% Basic comparisons (ANOVAs) on the collapsed data from 'FGsubject_v2'

% convert our results struct to table (easier to handle)

% searchDir = '/home/lucab/Downloads/FG-RT-master/SFG_all/';
% subjects = 2:132;
% FGdataTab = struct2table(FGsubject_v2(searchDir, subjects));

%FGdataTab = struct2table(FGdata);
allSubs = length(FGdataTab.subNumber);


% create primary grouping variable (young, old/good, old/impaired)
is_old = logical(FGdataTab.subNumber > 100);

hear_imp = ([103,108,109,110,111,113,115,116,119,120,121,125,127,128,129,130,132]); 

tmp = ismember(FGdataTab.subNumber, hear_imp);
isImpaired = double(tmp);

primaryGrouping =  zeros(allSubs, 1);
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

[an2, tab2, stats2] = anova1(FGdataTab.hitrate_all, primaryGrouping, 'off');
C2 = multcompare(stats2);

[an3, tab3, stats3] = anova1(FGdataTab.FArate_all, primaryGrouping, 'off');
C3 = multcompare(stats3);

[an4, tab4, stats4] = anova1(FGdataTab.accuracy, primaryGrouping, 'off');
C4 = multcompare(stats4);

[an5, tab5, stats5] = anova1(FGdataTab.mean_RT, primaryGrouping, 'off');
C5 = multcompare(stats5);

[an6, tab6, stats6] = anova1(FGdataTab.ToneCompdiff, primaryGrouping, 'off');
C6 = multcompare(stats6);                  
                  
[an7, tab7, stats7] = anova1(FGdataTab.figCoherence, primaryGrouping, 'off');
C7 = multcompare(stats7);  


% % 2-way ANOVA for accuracy
% [an8, tab8, stats8] = anovan(FGdataTab.accuracy, {FGdataTab.ToneCompdiff, FGdataTab.figCoherence}, ...
%                       'model', 2, 'display', 0, 'varnames', {'Tone Component diff', 'Figure Coherence'});
                  

%% 2 sample T-tests for testing the stimulus effect (easy/difficult)
% 'H' returns logical values for significance, 'Pttest' are P values, 'ci'
% returns confidence intervals, Tstats contains test statistic value, df,
% sd

% on accuracy measures
[H1, Pttest1, ci1, Tstats1] = ttest2(FGdataTab.DprimeEasy, FGdataTab.DprimeDiff); 
[H2, Pttest2, ci2, Tstats2] = ttest2(FGdataTab.hitrateEasy, FGdataTab.hitrateDiff); 
[H3, Pttest3, ci3, Tstats3] = ttest2(FGdataTab.FArateEasy, FGdataTab.FArateDiff);
[H4, Pttest4, ci4, Tstats4] = ttest2(FGdataTab.accuracy_easy, FGdataTab.accuracy_diff);

% on RT
[H5, Pttest5, ci5, Tstats5] = ttest2(FGdataTab.RTeasy, FGdataTab.RTdiff);
[H6, Pttest6, ci6, Tstats6] = ttest2(FGdataTab.RThitEasy, FGdataTab.RThitDiff);
[H7, Pttest7, ci7, Tstats7] = ttest2(FGdataTab.RTFAEasy, FGdataTab.RTFADiff);
                  




