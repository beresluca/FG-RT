%% Basic comparisons (ANOVAs) on the collapsed data from 'FGsubject_v2'

% convert our results struct to table (easier to handle)

FGdataTab = struct2table(FGdata);
allSubs = length(FGdataTab.subNumber);

is_old = logical(FGdataTab.subNumber > 100);

hear_imp = ([103,108,109,110,111,113,115,116,119,120,121,125,127,128,129,130,132]); 

tmp = ismember(FGdataTab.subNumber, hear_imp);
isImpaired = double(tmp);

primaryGrouping(isImpaired==0 & is_old==0) = 1;
primaryGrouping(isImpaired==0 & is_old==1) = 2;
primaryGrouping(isImpaired==1 & is_old==1) = 3;  

primaryGroupingRe = reshape(primaryGrouping, [allSubs, 1]);


% One-way ANOVAs for the 3 groups
[an1, tab1, stats1] = anova1(FGdataTab.DprimeEasy, primaryGroupingRe, 'off');
C1 = multcompare(stats1);

[an2, tab2, stats2] = anova1(FGdataTab.DprimeDiff, primaryGroupingRe, 'off');
C2 = multcompare(stats2);

[an3, tab3, stats3] = anova1(FGdataTab.figCoherence, primaryGroupingRe, 'off');
C3 = multcompare(stats3);

[an4, tab4, stats4] = anova1(FGdataTab.ToneCompdiff, primaryGroupingRe, 'off');
C4 = multcompare(stats4);


% 2-way ANOVA for accuracy
[an5, tab5, stats5] = anovan(FGdataTab.accuracy, {FGdataTab.ToneCompdiff, FGdataTab.figCoherence}, ...
                      'display', 0, 'varnames', {'Tone Component diff', 'Figure Coherence'});
                  
                  