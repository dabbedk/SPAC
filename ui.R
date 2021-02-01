library(shinydashboard)

shinyUI(dashboardPage(
    dashboardHeader(title = 'SPAC Mergers'),
    
    dashboardSidebar(
        sidebarMenu(
            menuItem('Intro', tabName = 'intro', icon = icon('info-circle')),
            
            menuItem('General', tabName = 'general', icon = icon('search-dollar')),
            
            menuItem('Price Movement', tabName = 'price', icon = icon('poll')),
            
            menuItem('SPAC Index', tabName = 'spacIndex', icon = icon('layer-group')),
            
            menuItem('Index Comparison', tabName = 'indexComp', icon = icon('layer-group'))
        )
    ),
    
    dashboardBody(
        tabItems(
            tabItem(tabName = 'intro',
                    'about me and intro to project'
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