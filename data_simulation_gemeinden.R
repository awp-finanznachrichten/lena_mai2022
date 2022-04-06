set.seed(i)

#Daten simulieren Gemeinde!!! 
for (a in 1:nrow(results)) {   #seq(1,nrow(results),2)

results$gebietAusgezaehlt[a] = TRUE

results$jaStimmenAbsolut[a] <- sample(0:10000,1)
results$neinStimmenAbsolut[a] <- sample(0:10000,1)
results$gueltigeStimmen[a] <- results$jaStimmenAbsolut[a] + results$neinStimmenAbsolut[a]
results$jaStimmenInProzent[a] <- results$jaStimmenAbsolut[a]*100/results$gueltigeStimmen[a]

}
