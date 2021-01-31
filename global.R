library(tidyverse)
library(shiny)
library(wordcloud)
library(RColorBrewer)
library(shinydashboard)

setwd('./data')


# Clean Merged SPAC data ----

merged.df = read_csv('closedspacs.csv')

merged.df = merged.df %>%
  select(1, 2, 4, 5, 14:17)

names(merged.df) = c('Post-SPAC.Ticker', 'Post-SPAC.Company', 'SPAC.Ticker',
                    'Completion.Date', 'IPO.Date', 'SPAC.Size.in.Millions', 'Target.Industry', 'Notable.Leadership')

str_replace_all(merged.df$SPAC.Size.in.Millions, '\\W', '') %>%
  as.numeric() -> merged.df$SPAC.Size.in.Millions

str_extract(merged.df[[3]], '[[:punct:]][[:upper:]]{3,}[[:punct:]]') %>%
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
  mutate(Day = row_number(Date))


# Clean up and combine Indexes into single file ----
  
setwd('../indexes')

indexes = list.files()
  
indexList = lapply(indexes, cleanup)
  
indexDailySP = do.call('rbind', indexList)


# Wordcloud

merged.df %>%
  filter(!is.na(merged.df$Target.Industry)) %>%
  select(Target.Industry) -> wordList

wordList = paste(merged.df$Target.Industry[!is.na(merged.df$Target.Industry)], collapse = ',')
wordList = str_to_lower(wordList)

wordList = str_replace_all(wordList, '(and)|(\\son\\s)|(focus)|(tmt)|(focus)', '')
wordList = str_replace_all(wordList, '[\\( | \\)]', '')
wordList = str_split(wordList, ',')

wordList = wordList[[1]]

wordCount = data.frame(word = wordList)

wordCount <- wordCount %>%
  group_by(word) %>%
  mutate(freq = sum(n())) %>%
  unique()

# Create equalWeightdf

dailySP %>%
  filter(Date >= max(dailySP$IPO.Date)) %>%
  group_by(Date) %>%
  mutate(SPAC.Index = sum(Close)) -> equalWeight.df

indexDailySP %>% 
  select(-Volume) %>% 
  pivot_wider(names_from = Ticker, values_from = Close) -> indexDailySP

inner_join(equalWeight.df, indexDailySP, by = 'Date') -> equalWeight.df

