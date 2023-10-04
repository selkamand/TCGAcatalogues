create_all_datasets <- function(outdir = "inst", source = "MC3"){
  rlang::check_installed("sigminer")
  rlang::check_installed("dplyr")
  rlang::check_installed("maftools")
  rlang::check_installed("readr")

  # Configurable
  df_studies = maftools::tcgaAvailable()
  studies = df_studies[['Study_Abbreviation']][!is.na(df_studies[[source]])]

  for (study in studies){
    message('--------  Loading study: ', study, ' --------')
    maf = maftools::tcgaLoad(study, source =  source)
    tally <- sigminer::sig_tally(
      maf,
      ref_genome = "BSgenome.Hsapiens.UCSC.hg19",
      use_syn = TRUE
    )

    for (mxtype in names(tally$all_matrices)){
      mx = tally$all_matrices[[mxtype]]
      outfile_name = paste0(outdir,'/', study, '.', source, '.', mxtype, '.hg19.csv')
      df <- as.data.frame(mx)
      channels <- colnames(mx)
      df[['sample']] <- row.names(df)

      dflong <- tidyr::pivot_longer(df, cols = channels, names_to = "channel", values_to = "count")
      dflong[['fraction']] <- stats::ave(dflong[['count']], dflong[['sample']], FUN = \(counts){counts / sum(counts)})
      dflong[['type']] <- compute_type(dflong$channel)
      dflong <- dflong[c('sample', 'channel', 'type', 'fraction', 'count')]
      readr::write_csv(dflong, outfile_name)
    }
  }
}


compute_type <- function(channels){
  dplyr::case_when(
    grepl(x=channels, pattern = 'C>A') ~ 'C>A',
    grepl(x=channels, pattern = 'C>G') ~ 'C>G',
    grepl(x=channels, pattern = 'C>T') ~ 'C>T',
    grepl(x=channels, pattern = 'T>A') ~ 'T>A',
    grepl(x=channels, pattern = 'T>C') ~ 'T>C',
    grepl(x=channels, pattern = 'T>G') ~ 'T>G',
    TRUE ~ 'error'
  )


}
