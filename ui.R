library(shinydashboard)

shinyUI(dashboardPage(
    dashboardHeader(title = 'SPAC Mergers'),
    
    dashboardSidebar(
        sidebarMenu(
            menuItem('About', tabName = 'intro', icon = icon('info-circle')),
            
            menuItem('Negotiations', tabName = 'general', icon = icon('search-dollar')),
            
            menuItem('Price by Ticker', tabName = 'price', icon = icon('poll')),
            
            menuItem('My SPAC Index', tabName = 'spacIndex', icon = icon('layer-group')),
            
            menuItem('Indices', tabName = 'indexComp', icon = icon('search-dollar'))
        )
    ),
    
    dashboardBody(
        tabItems(
            tabItem(tabName = 'intro',
                    
                    fluidRow(column(8, align = 'center',
                                    box(h1('Analyzing 2020: Year of the SPAC')))),
                    
                    fluidRow(column(8,
                                    box(h3('This app was created to take a deeper look at the 2020 stock market trend of companies entering the public market through speical purpose acquisition companies (SPAC).
                                        As a cheaper and faster alternative to raise capital than a initial public offering (IPO), hundreds of these \'blank check companies\' raised multi-billion dollars from investors.'),
                                        br(), br(),
                                        tags$img(src = 'introimage.jpg', width = '400px', height = '400px'),
                                        br(), br(),
                                        h3('I researched 71 successful mergers between SPACs and their respective target companies to assess their performance both individually and cumulatively.
                                        You will be able to assess the performance of each SPAC pre- and post-merger, and compare the performance of the group through a mock \'SPAC Index\' that I created to compare against popular market indices.')))),
    
            ),
            
            tabItem(tabName = 'general',
                    
                    h3('Company Enterprise Valuation in $ Millions'),
                    fluidRow(box(valueBoxOutput('minSize'),
                                 valueBoxOutput('avgSize'),
                                 valueBoxOutput('maxSize'), height = 120, width = 12, status = 'success')),
                    
                    
                    
                    fluidRow(
                        box(plotOutput('SPACVolume', height = 505), height = 520, width = 6),
                        box(plotOutput('wordCloud', height = 520), height = 520, width = 6)
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
                                                choices = unique(dailySP$Ticker))))
            ),
            
            tabItem(tabName = 'spacIndex',
                    
                    fluidRow(box(plotOutput('dailySPACIndex'), width = 12)),
                    br(),
                    br(),
                    fluidRow(box(plotOutput('mergerComparison'), width = 8),
                             column(width = 4,
                                    box(valueBoxOutput('postMax'), title = 'Highest Price', width = NULL, background = 'green'),
                                    box(valueBoxOutput('postMed'), title = 'Median Price', width = NULL, background = 'yellow'),
                                    box(valueBoxOutput('postMin'), title = 'Lowest Price', width = NULL, background = 'red')
                             )
                    )

            ),
            
            tabItem(tabName = 'indexComp',
                    
                    fluidRow(box(plotOutput('indexComps'),
                                 width = 12))
                    )
        )
    )
)
)