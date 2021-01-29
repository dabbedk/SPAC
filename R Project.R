library(tidyverse)

setwd('./data')


# Clean Merged SPAC data ----

merged.df = read_csv('closedspacs.csv')

merged.df = merged.df %>%
  select(1, 2, 4, 5, 14:17)

names(merged.df) = c('Post-SPAC.Ticker', 'Post-SPAC.Company', 'SPAC.Ticker',
                    'Completion.Date', 'IPO.Date', 'SPAC.Size.in.Millions', 'Target.Industry', 'Notable.Leadership')

str_extract(clean.df[[3]], '[[:punct:]][[:upper:]]{3,}[[:punct:]]') %>%
  str_extract('\\w{3,}') -> SPACtickers

merged.df$SPAC.Ticker = SPACtickers


# Clean up and combine stock price files into single file ----

setwd('./dailysp')
files = list.files(pattern = '*.csv')

df = data.frame()

cleanup <- function(x) {
  
  newfile = read_csv(x)
  
  ticker = str_extract(x, '[:UPPER:]{1,4}')
  
  newfile$Date = as.Date(newfile$Date, '%Y-%m-%d')
  
  newfile %>%
    select(Date, Close, Volume) %>%
    mutate(Ticker = ticker) -> newfile
  
  df = rbind(df, newfile)
}

cleanList = lapply(files, cleanup)

DailySP = do.call('rbind', cleanList)


# Clean up and combine Indexes into single file ----
  
setwd('../indexes')

indexes = list.files()
  
IndexList = lapply(indexes, cleanup)
  
IndexDailySP = do.call('rbind', IndexList)


