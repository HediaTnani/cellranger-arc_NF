#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// Include the CellRangerARC_Count process from the separate file
include { CellRangerARC_Count } from './modules/CellrangerArcCount.nf'

workflow {
    // Create a channel for the CSV files, using $launchDir
    csvChannel = Channel.fromPath("./librairies/*.csv")

    // Process the file paths to extract sample IDs and form tuples
    tupleChannel = csvChannel.map { path ->
        def parts = path.getBaseName().split(/_/).collect { it.replaceAll(/\\.csv$/, '') }
        def sampleId = parts[1..-1].join('_')
        tuple(sampleId, path)
    }

    // Run the CellRangerARC_Count process
    tupleChannel | CellRangerARC_Count
}
