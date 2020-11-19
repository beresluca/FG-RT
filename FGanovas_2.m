%% Basic comparisons (ANOVAs) on the collapsed data from 'FGsubject_v2'

% convert our results struct to table (easier to handle)
FGdataTab = struct2table(FGdata);
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


% get mean RT-s per stim type
RTtemp1 = cell2mat(FGdataTab.mean_stmType(:,1));
meanRTeasy = RTtemp1(1:end,1);

RTtemp2 = cell2mat(FGdataTab.mean_stmType(1:end));
meanRTdiff = RTtemp2(1:end,2);
% why are these 104 long instead of 52?


% 2 sample T tests for easy/difficult 
[H1, Pttest1, ci1, Tstats1] = ttest2(FGdataTab.DprimeEasy, FGdataTab.DprimeDiff); 
[H2, Pttest2, ci2, Tstats2] = ttest2(FGdataTab.hitrateEasy, FGdataTab.hitrateDiff); 
[H3, Pttest3, ci3, Tstats3] = ttest2(FGdataTab.FArateEasy, FGdataTab.FArateDiff); 


% One-way ANOVAs for the 3 groups
[an1, tab1, stats1] = anova1(FGdataTab.DprimeEasy, primaryGrouping, 'off');
C1 = multcompare(stats1);

[an2, tab2, stats2] = anova1(FGdataTab.DprimeDiff, primaryGrouping, 'off');
C2 = multcompare(stats2);

[an3, tab3, stats3] = anova1(FGdataTab.figCoherence, primaryGrouping, 'off');
C3 = multcompare(stats3);

[an4, tab4, stats4] = anova1(FGdataTab.ToneCompdiff, primaryGrouping, 'off');
C4 = multcompare(stats4);

[an5, tab5, stats5] = anova1(FGdataTab.hitrateEasy, primaryGrouping, 'off');
C5 = multcompare(stats5);

[an6, tab6, stats6] = anova1(FGdataTab.hitrateDiff, primaryGrouping, 'off');
C6 = multcompare(stats6);

% 2-way ANOVA for accuracy
[an7, tab7, stats7] = anovan(FGdataTab.accuracy, {FGdataTab.ToneCompdiff, FGdataTab.figCoherence}, ...
                      'display', 0, 'varnames', {'Tone Component diff', 'Figure Coherence'});
                  
                  
