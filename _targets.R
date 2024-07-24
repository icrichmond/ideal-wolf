# Source ------------------------------------------------------------------
library(targets)
tar_source('R')


# Options -----------------------------------------------------------------
# Targets
tar_option_set(format = 'qs')



# Targets -----------------------------------------------------------------

c(
  
  tar_file_read(
    kills_raw,
    'data/killdata/2021-09-17_RMNP_Matched_Sites_sortedClu.csv',
    read.csv(!!.x)
  ),
  
  tar_file_read(
    summ_data,
    'data/2021-09-19-Bloc-DielModel.csv',
    read.csv(!!.x)
  )
  
  
  
)