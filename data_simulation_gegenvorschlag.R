#Daten simulieren Gegenvorschlag!!!
for (a in 1:nrow(results_gegenvorschlag)) { 
  
  results_gegenvorschlag$gebietAusgezaehlt[a] = TRUE
  
  results_gegenvorschlag$jaStimmenAbsolut[a] <- sample(0:10000,1)
  results_gegenvorschlag$neinStimmenAbsolut[a] <- sample(0:10000,1)
  results_gegenvorschlag$gueltigeStimmen[a] <- results_gegenvorschlag$jaStimmenAbsolut[a] + results_gegenvorschlag$neinStimmenAbsolut[a]
  results_gegenvorschlag$jaStimmenInProzent[a] <- results_gegenvorschlag$jaStimmenAbsolut[a]*100/results_gegenvorschlag$gueltigeStimmen[a]
  
}

#Daten simulieren Stichentscheid
for (a in 1:nrow(results_gegenvorschlag)) { 
  
  results_gegenvorschlag$gebietAusgezaehlt[a] = TRUE
  
  results_gegenvorschlag$jaStimmenAbsolut[a] <- sample(0:10000,1)
  results_gegenvorschlag$neinStimmenAbsolut[a] <- sample(0:10000,1)
  results_gegenvorschlag$gueltigeStimmen[a] <- results_gegenvorschlag$jaStimmenAbsolut[a] + results_gegenvorschlag$neinStimmenAbsolut[a]
  results_gegenvorschlag$jaStimmenInProzent[a] <- results_gegenvorschlag$jaStimmenAbsolut[a]*100/results_gegenvorschlag$gueltigeStimmen[a]
  
}



