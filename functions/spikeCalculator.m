function results = spikeCalculator(spikeList)

resultsPerElectrode = spikeCalcIndiv(spikeList);
resultsPerWell = spikeCalcWell(spikeList);