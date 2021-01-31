shinyServer(function(input, output){
    
    
    output$wordCloud <- renderPlot({
        
        wordcloud(wordCount$word, wordCount$freq, min.freq = 1, color = brewer.pal(8, 'Dark2'),
                  random.order = F, random.color = F, scale = c(4, 1))
        
    })
    
    output$SPACVolume <- renderPlot({
        
        ggplot(data = dailySP) +
            geom_point(aes(x = Date, y = Volume), stat = 'identity', size = 2) +
            theme_bw() +
            labs(x = 'Year', y = 'Volume', title = 'Daily Trading Volume') +
            scale_y_continuous(labels = scales::comma)
        
    })
    
    output$dailySPACIndex <- renderPlot({
        
        ggplot(data = equalWeight.df, aes(x = Date)) +
            geom_line(aes(y = SPAC.Index), stat = 'identity') +
            theme_bw() +
            labs(x = 'Date',
                 y = 'Closing Price',
                 title = 'My SPAC Index Performance',
                 subtitle = 'Equal Weighted Index')
        
    })
    
    output$mergerComparison <- renderPlot({
        
        equalWeight.df$Status <- factor(equalWeight.df$Status, levels = c('Pre-Merger', 'Post-Merger'))  
        
        equalWeight.df %>%
            group_by(Status, Day) %>%
            summarize(Price = sum(Close)) %>%
            ggplot() +
            theme_bw() +
            labs(x = 'Day',
                 y = 'Closing Price',
                 title = 'Comparing Index Pre- vs Post-Merger',
                 subtitle = 'Equal Weighted Index') +
            geom_smooth(aes(x = Day, y = Price, color = Status), stat= 'identity') +
            scale_color_manual(values = c('forestgreen', 'red')) +
            facet_grid( ~ Status)
        
    })
    
    
    output$minSize <- renderInfoBox({
        min_size = min(merged.df$SPAC.Size.in.Millions)
        min_company = merged.df$`Post-SPAC.Company`[merged.df$SPAC.Size.in.Millions == min_size]
        valueBox(min_size / 10, min_company, icon = icon('dollar-sign'), width = 4, color = 'olive')
    })
    
    output$avgSize <- renderInfoBox({
        avg_size = round(mean(merged.df$SPAC.Size.in.Millions))
        valueBox(avg_size / 10, 'Average', icon = icon('dollar-sign'), width = 4, color = 'olive')
        
    })
    
    output$maxSize <- renderInfoBox({
        max_size = max(merged.df$SPAC.Size.in.Millions)
        max_company = merged.df$`Post-SPAC.Company`[merged.df$SPAC.Size.in.Millions == max_size]
        valueBox(max_size / 10, max_company, icon = icon('dollar-sign'), width = 4, color = 'olive')
        
    }) 
    output$minTime <- renderInfoBox({
        min_time = min(merged.df$Merger.Timeline.in.Days)
        min_ticker = merged.df$`Post-SPAC.Ticker`[merged.df$Merger.Timeline.in.Days == min_time]
        valueBox(paste(min_time, 'Days'), min_ticker, icon = icon('calendar-alt'), width = 4, color = 'orange')
    })

    output$avgTime <- renderInfoBox({
        avg_time = mean(merged.df$Merger.Timeline.in.Days)
        valueBox(paste(round(avg_time), 'Days'), 'Average', icon = icon('calendar-alt'), width = 4, color = 'orange')
        
    })
    
    output$maxTime <- renderInfoBox({
        max_time = max(merged.df$Merger.Timeline.in.Days)
        max_ticker = merged.df$`Post-SPAC.Ticker`[merged.df$Merger.Timeline.in.Days == max_time]
        valueBox(paste(max_time, 'Days'), max_ticker, icon = icon('calendar-alt'), width = 4, color = 'orange')
        
    })
    
    output$dailyReturns <- renderPlot({
        
        dailySP %>%
            filter(Ticker == input$Ticker) %>%
            ggplot(aes(x = Date, y = Close, color = Status)) +
            geom_line(stat = 'identity') +
            scale_color_hue(l = 50) +
            theme_bw() +
            labs(x = 'Date', y = 'Closing Price', title = 'Price Movement Pre- vs Post-Merger') +
            scale_y_continuous(labels = scales::dollar)
        
    })

    
})