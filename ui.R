library(shinydashboard)

shinyUI(dashboardPage(
    dashboardHeader(title = 'SPAC Mergers'),
    
    dashboardSidebar(
        sidebarMenu(
            menuItem('About', tabName = 'intro', icon = icon('info-circle')),
            
            menuItem('Negotiations', tabName = 'general', icon = icon('search-dollar')),
            
            menuItem('Price by Ticker', tabName = 'price', icon = icon('poll')),
            
            menuItem('My SPAC Index', tabName = 'spacIndex', icon = icon('layer-group')),
            
            menuItem('Indices', tabName = 'indexComp', icon = icon('search-dollar')),
            
            menuItem('Researcher', tabName = 'aboutme', icon = icon('user'))
        )
    ),
    
    dashboardBody(
        tabItems(
            tabItem(tabName = 'intro',
                    
                    fluidRow(column(8, align = 'center',
                                    box(h4('Analyzing 2020: Year of the SPAC'), width = 12))),
                    
                    fluidRow(column(8, align = 'center',
                                    box(h6('This app was created to take a deeper look at the 2020 stock market trend of companies entering the public market through special purpose acquisition companies (SPAC).
                                        As a cheaper and faster alternative to raise capital than a traditional initial public offering (IPO), hundreds of these \'blank check companies\' raised multi-billion dollars from investors.'),
                                        br(), br(),
                                        tags$img(src = 'introimage.jpg', width = '200px', height = '200px'),
                                        br(), br(),
                                        h6('I researched 71 successful SPAC mergers in 2020 - Jan/2021 to assess their performance both individually and cumulatively.
                                        You will be able to assess the performance of each SPAC pre- and post-merger, and compare the performance of the group through a mock \'SPAC Index\' that I created to compare against popular market indices.'),
                                        width = 12))),
    
            ),
            
            tabItem(tabName = 'general',
                    
                    h3('Company Enterprise Valuation in $ Millions'),
                    fluidRow(box(valueBoxOutput('minSize'),
                                 valueBoxOutput('avgSize'),
                                 valueBoxOutput('maxSize'), height = 120, width = 12, status = 'success')),
                    
                    
                    
                    fluidRow(
                        box(plotOutput('SPACVolume', height = 505), height = 520, width = 6),
                        box(h5('Popular Target Company Industries:'),
                            plotOutput('wordCloud', height = 520), height = 520, width = 6)
                    ),
                    
                    h3('Merger Timelines'),
                    fluidRow(box(valueBoxOutput('minTime'),
                                 valueBoxOutput('avgTime'),
                                 valueBoxOutput('maxTime'), height = 120, width = 12, status = 'warning'))
            ),
            
            
            tabItem(tabName = 'price',
                    
                    fluidRow(box(plotOutput('dailyReturns'),
                                 width = 12)),
                    
                    fluidRow(box(selectizeInput(inputId = 'Ticker',
                                                label = 'Ticker Symbol',
                                                choices = unique(dailySP$Ticker))),
                             box('Based on this graph, we can conclude that while SPACs generally stay above $10 pre-merger, the price movement can vary drastically post-merger.',
                                 title = 'Assessment', solidHeader = T, status = 'primary'))
            ),
            
            tabItem(tabName = 'spacIndex',
                    
                    fluidRow(box(plotOutput('dailySPACIndex'), width = 12),
                             box('The chart above shows price movement for a hypothetical SPAC index that I created. The price tracks back to the first day that the last of the 71 companies completed its IPO. Overall, you can see that it has a positive trend.',
                                 br(),
                                 'The chart below tracks the average price of SPACs pre- and post-merger by day, rather than date. It would be more insightful to compare the relationship between merger day and price movement.',
                                 br(),
                                 'We can see that the prices generally stay similar or above the IPO price, but the risk/reward is dramatic post-merger, exemplified by the min and max prices shown on the bottom-right.',
                                 title = 'Assessment', solidHeader = T, status = 'primary', width = 12)),
                    br(),
                    br(),
                    fluidRow(
                        box(plotOutput('mergerComparison'), width = 8),
                             column(width = 4,
                                    box(valueBoxOutput('postMax'), title = 'Highest Price', width = NULL, background = 'green'),
                                    box(valueBoxOutput('postMed'), title = 'Median Price', width = NULL, background = 'yellow'),
                                    box(valueBoxOutput('postMin'), title = 'Lowest Price', width = NULL, background = 'red')
                             ),
                        
                    )

            ),
            
            tabItem(tabName = 'indexComp',
                    
                    fluidRow(box(plotOutput('indexComps'),
                                 width = 12),
                             box('The chart above shows my hypothetical SPAC index movement compared to popular market indices. For improved comparison, I rescaled the graphs to show the range in movement between their respective minimum and maximum prices.',
                                 br(),br(),
                                 'While the SPAC index lagged slightly below the other 3 last summer, it has maintained a positive trend and has recently caught up to the other indices.',
                                 title = 'Assessment', solidHeader = T, status = 'primary', width = 12))
                    ),
            
            tabItem(tabName = 'aboutme',
                    
                    fluidRow(box(align = 'center', h1('David Kim'),
                                 br(), br(),
                                 h3(tags$a(href = 'https://github.com/dabbedk/SPAC', 'GitHub'), ' | ',
                                    tags$a(href = 'https://www.linkedin.com/in/david-kim-4672a396/', 'LinkedIn'))))
                    
            )           
        )
    )
)
)