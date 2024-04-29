// CellrangerArcCount.nf
process CellRangerARC_Count {
    tag "${sampleId}"
    label 'medium'
    publishDir "$params.outdir/00_CellrangerArc_count", mode: 'copy', overwrite: true

    input:
    tuple val(sampleId), path(csvPath)

    output:
    path ("${sampleId}")

    script:
    def reference
    if (params.organism == 'mouse') {
        reference = "/10x/refdata-cellranger-arc-mm10-2020-A-2.0.0"
    } else if (params.organism == 'human') {
        reference = "/10x/refdata-cellranger-arc-GRCh38-2020-A-2.0.0"
    } else {
        error "Unsupported organism: ${params.organism}. Please specify 'mouse' or 'human'."
    }

    """
    echo "Processing sample ${sampleId}"
    mkdir -p "${sampleId}"
    echo "${sampleId} folder created"
    echo "Running cellranger-arc count for ${sampleId}" 
    echo "**** Job starts ****"
    date 
    echo "Allocated cpu: ${task.cpus}"
    echo "Allocated memory: ${task.memory.toGiga()} GB"
    cellranger-arc count --id=${sampleId} \\
        --reference=${reference} \\
        --libraries=${csvPath} \\
        --localcores=${task.cpus} \\
        --localmem=${task.memory.toGiga()}
    echo "**** Job ends ****"
    echo "Cellranger-arc count ended for ${sampleId}" 
    date
    """
}

