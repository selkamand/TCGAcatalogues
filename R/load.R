#' Check for available catalogue datasets.
#'
#' This function lists the available catalogue datasets included in the TCGAdecomp package.
#'
#' @return A data frame with information about available datasets, including dataset name, source,
#'         type, genome, and file extension.
#'
#' @export
#' @examples
#'
#' # List available datasets
#' decomp_available()
#'
#' # Load datasets
#' decomp_collection_acc <- decomp_load('ACC')
#'
#' # Load datasets as data.frames
#' decomp_dataframe_acc <- decomp_load('ACC', dataframe = TRUE)
#'
decomp_available <- function(){
  # Get the package folder path
  folder = system.file(package = 'TCGAdecomp')

  # List CSV files in the package folder
  paths = dir(folder, pattern = ".csv.gz")

  # Split the filenames to extract dataset information
  ls_paths = strsplit(basename(paths), split = "\\.")

  # Create a data frame with dataset information
  df_datasets =  as.data.frame(do.call(rbind, args=ls_paths))
  colnames(df_datasets) <- c('dataset', 'source', 'type', 'genome', 'extension', 'compression')

  # Convert to a tibble
  df_datasets <- tibble::tibble(df_datasets)

  # Remove the 'extension' column
  df_datasets <- df_datasets[-c(5, 6)]

  # Return the dataset information
  return(df_datasets)
}


#' Load a catalogue dataset.
#'
#' This function loads a specific catalogue dataset based on the provided dataset name, source,
#' type, and genome. It can also return the loaded dataset as a data frame.
#'
#' @param dataset Name of the dataset to load.
#' @param source The source of the dataset (e.g., 'MC3' or 'Firehose').
#' @param type The type of catalogue (e.g., 'SBS_96' or 'SBS_6').
#' @param genome The genome version (e.g., 'hg19' or 'hg38').
#' @param dataframe Logical indicating whether to return the loaded dataset as a data frame (default: FALSE).
#'
#' @return A sigverse style catalogue collection (a list of data frames, each containing catalogue data for a unique sample).
#'         If dataframe is TRUE, a single data frame with the entire dataset is returned.
#' @export
#' @inherit decomp_available examples
decomp_load <- function(dataset, source = c('MC3', 'Firehose'), type = c('SBS_96', 'SBS_6','SBS_1536', 'DBS_78', 'DBS_1248', 'ID83'), genome = c('hg19', 'hg38'), dataframe = FALSE){
  # Assertions
  assertions::assert_string(dataset)
  assertions::assert_flag(dataframe)

  # Match source, type, and genome to predefined values
  source <- rlang::arg_match(source)
  type <- rlang::arg_match(type)
  genome <- rlang::arg_match(genome)


  # Get information about available datasets
  df_available <- decomp_available()

  # Generate the expected filename for the specified dataset
  filename <- paste(dataset, source, type, genome, 'csv.gz', sep = ".")

  # Get the full filepath for the dataset
  filepath <- system.file(filename, package = "TCGAdecomp")

  # Check if the file exists
  assertions::assert_file_exists(
    filepath,
    msg = '
    Failed to find an appropriate catalogue for dataset: [{dataset}].
    Please run {.code decomp_available() to see all available datasets}
    '
  )

  # Read the dataset from the CSV file
  df_dataset <- utils::read.csv(filepath, header = TRUE)
  df_dataset <- tibble::tibble(df_dataset)

  # If return_df is FALSE, split the dataset by sample and return as a list
  if(!dataframe){
    ls_catalogues <- split(df_dataset[-1], df_dataset[["sample"]])
    return(ls_catalogues)
  }

  # If return_df is TRUE, return the entire dataset as a data frame
  return(df_dataset)
}
