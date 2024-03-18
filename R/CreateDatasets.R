create_all_datasets <- function(outdir = "inst", source = "MC3"){
  rlang::check_installed("sigminer")
  rlang::check_installed("dplyr")
  rlang::check_installed("maftools")
  rlang::check_installed("readr")

  # Configurable
  df_studies = maftools::tcgaAvailable()
  studies = df_studies[['Study_Abbreviation']][!is.na(df_studies[[source]])]

  for (study in studies) {
    message('--------  Loading study: ', study, ' --------')
    maf = maftools::tcgaLoad(study, source =  source)
    tally <- sigminer::sig_tally(
      maf,
      ref_genome = "BSgenome.Hsapiens.UCSC.hg19",
      use_syn = TRUE,
      mode = "ALL"
    )

    for (mxtype in names(tally)) {
      if (mxtype %in% c("APOBEC_scores", "ID_28")) { next } # Skip certain parts of the matrix
      mx = tally[[mxtype]]
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
    # SBS
    grepl(x=channels, pattern = '[C>A]', fixed = TRUE) ~ 'C>A',
    grepl(x=channels, pattern = '[C>G]', fixed = TRUE) ~ 'C>G',
    grepl(x=channels, pattern = '[C>T]', fixed = TRUE) ~ 'C>T',
    grepl(x=channels, pattern = '[T>A]', fixed = TRUE) ~ 'T>A',
    grepl(x=channels, pattern = '[T>C]', fixed = TRUE) ~ 'T>C',
    grepl(x=channels, pattern = '[T>G]', fixed = TRUE) ~ 'T>G',

    # DBS
    grepl(x=channels, pattern = "AC>[A-Z][A-Z]") ~ "AC>NN",
    grepl(x=channels, pattern = "AT>[A-Z][A-Z]") ~ "AT>NN",
    grepl(x=channels, pattern = "CC>[A-Z][A-Z]") ~ "CC>NN",
    grepl(x=channels, pattern = "CG>[A-Z][A-Z]") ~ "CG>NN",
    grepl(x=channels, pattern = "CT>[A-Z][A-Z]") ~ "CT>NN",
    grepl(x=channels, pattern = "GC>[A-Z][A-Z]") ~ "GC>NN",
    grepl(x=channels, pattern = "TA>[A-Z][A-Z]") ~ "TA>NN",
    grepl(x=channels, pattern = "TC>[A-Z][A-Z]") ~ "TC>NN",
    grepl(x=channels, pattern = "TG>[A-Z][A-Z]") ~ "TG>NN",
    grepl(x=channels, pattern = "TT>[A-Z][A-Z]") ~ "TT>NN",

    # ID
    grepl(x=channels, pattern = "1:Del:C", fixed = TRUE) ~ "1:Del:C",
    grepl(x=channels, pattern = "1:Del:T", fixed = TRUE) ~ "1:Del:T",
    grepl(x=channels, pattern = "1:Ins:C", fixed = TRUE) ~ "1:Ins:C",
    grepl(x=channels, pattern = "1:Ins:T", fixed = TRUE) ~ "1:Ins:T",
    grepl(x=channels, pattern = "2:Del:R", fixed = TRUE) ~ "2:Del:R",
    grepl(x=channels, pattern = "3:Del:R", fixed = TRUE) ~ "3:Del:R",
    grepl(x=channels, pattern = "4:Del:R", fixed = TRUE) ~ "4:Del:R",
    grepl(x=channels, pattern = "5:Del:R", fixed = TRUE) ~ "5:Del:R",
    grepl(x=channels, pattern = "2:Ins:R", fixed = TRUE) ~ "2:Ins:R",
    grepl(x=channels, pattern = "3:Ins:R", fixed = TRUE) ~ "3:Ins:R",
    grepl(x=channels, pattern = "4:Ins:R", fixed = TRUE) ~ "4:Ins:R",
    grepl(x=channels, pattern = "5:Ins:R", fixed = TRUE) ~ "5:Ins:R",
    grepl(x=channels, pattern = "2:Del:M", fixed = TRUE) ~ "2:Del:M",
    grepl(x=channels, pattern = "3:Del:M", fixed = TRUE) ~ "3:Del:M",
    grepl(x=channels, pattern = "4:Del:M", fixed = TRUE) ~ "4:Del:M",
    grepl(x=channels, pattern = "5:Del:M", fixed = TRUE) ~ "5:Del:M",

    TRUE ~ 'error'
  )


}
