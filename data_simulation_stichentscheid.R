#Daten simulieren Stichentscheid
for (a in 1:nrow(results_stichentscheid)) { 
  
  results_stichentscheid$gebietAusgezaehlt[a] = TRUE
  
  results_stichentscheid$jaStimmenAbsolut[a] <- sample(0:10000,1)
  results_stichentscheid$neinStimmenAbsolut[a] <- sample(0:10000,1)
  results_stichentscheid$gueltigeStimmen[a] <- results_stichentscheid$jaStimmenAbsolut[a] + results_stichentscheid$neinStimmenAbsolut[a]
  results_stichentscheid$jaStimmenInProzent[a] <- results_stichentscheid$jaStimmenAbsolut[a]*100/results_stichentscheid$gueltigeStimmen[a]
  
}



