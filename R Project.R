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

merged.df %>%
  mutate(Merger.Timeline.in.Days = Completion.Date - IPO.Date) %>%
  relocate(Merger.Timeline.in.Days, .after = IPO.Date) -> merged.df


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

dailySP = do.call('rbind', cleanList)

# add day and gain/loss columns

merged.df %>%
  select(1,4,5) -> dates

dailySP <- merge(dailySP, dates, by.x = 'Ticker', by.y = 'Post-SPAC.Ticker') %>%
  mutate(Status = ifelse(Date < Completion.Date, 'Pre-Merger', 'Post-Merger')) %>%
  group_by(Ticker, Status) %>%
  mutate(Day = row_number(Date)) %>%
  mutate(GainLoss.byPercent =
           case_when(Day == 1 ~ 0,
                     Day > 1 ~ round(
                       (((Close - Close[Day == 1]) / Close[Day == 1])* 100)
                       , 2)
           ))


# Clean up and combine Indexes into single file ----
  
setwd('../indexes')

indexes = list.files()
  
indexList = lapply(indexes, cleanup)
  
indexDailySP = do.call('rbind', indexList)


