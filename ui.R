library(shinydashboard)

shinyUI(dashboardPage(
    dashboardHeader(title = 'SPAC Mergers'),
    
    dashboardSidebar(
        sidebarMenu(
        menuItem('Intro', tabName = 'intro', icon = icon('info-circle')),
        
        menuItem('General', tabName = 'general', icon = icon('search-dollar')),
        
        menuItem('Price Movement', tabName = 'price', icon = icon('poll'))
        )
    ),
    
    dashboardBody(
        tabItems(
            tabItem(tabName = 'intro',
                    'about me and intro to project'),
            
            tabItem(tabName = 'general',
                    
                    h3('Company Enterprise Valuation in $ Millions'),
                    fluidRow(box(valueBoxOutput('minSize'),
                                 valueBoxOutput('avgSize'),
                                 valueBoxOutput('maxSize'), height = 120, width = 12, status = 'success')),
                    
                    
                    
                    fluidRow(box(plotOutput('wordCloud', height = 520), height = 532, width = 12)),
                    
                    h3('Merger Timelines'),
                    fluidRow(box(valueBoxOutput('minTime'),
                                 valueBoxOutput('avgTime'),
                                 valueBoxOutput('maxTime'), height = 120, width = 12, status = 'warning'))
                    ),
            
        
            tabItem(tabName = 'price',

                    fluidRow(box(plotOutput('dailyReturns', height = 350),
                                 height = 400, width = 12)),
                    
                    fluidRow(box(selectizeInput(inputId = 'Ticker',
                                                label = 'Ticker Symbol',
                                                choices = unique(dailySP$Ticker))))
         
            )
        )
    )
)
)