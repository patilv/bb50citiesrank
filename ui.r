library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("50 Best US Cities of 2012 - Ranked by Bloomberg Businessweek - Location and Characteristics"), #Application title
  
   # User input for determine characteristic to use for sizing dots on map
  sidebarPanel(
    selectInput("var1", "Characteristic 1:",
                 choices =c(
                "Number of Bars"="Bars",
                "Population"="Population",
                "Number of Restaurants"="Restaurants",
                "Number of Museums"="Museums",
                "Number of Libraries"="Libraries",
                "Number of Pro Sports Teams"="Pro.Sports.Teams",
                "Parks acres per 1000 residents"="Park.acres.per.1000.residents",
                "Number of Colleges"="Colleges",
                "Percent with Graduate Degree"="Percent.with.Graduate.Degree",
                "Median Household Income"="Median.household.income",
                "Percent Unemployed"="Percent.unemployed")
                  ),
                
                HTML("<br><br>"),
                h5(textOutput("hits")),# Hit counter Output
                HTML("<font size=1>Hit counter courtesy: <a href = 'http://www.econometricsbysimulation.com/2013/06/more-explorations-of-shiny.html' target='_blank'> Francis Smart</a></font>"),
                HTML("<br><br>Application code <a href = 'https://github.com/patilv/bb50cities' target='_blank'> is available here.</a>")
            ),
  
  
   mainPanel(
     HTML("<a href ='http://www.businessweek.com/articles/2012-09-26/san-francisco-is-americas-best-city-in-2012' target='_blank'> Original article </a> <font color='red'>
        required one to click on 50 slides to find the best city --- Advertising is important, right? </font><hr> "),
     
     tabsetPanel(
      # viewing the map
  tabPanel("Geographic Locations",HTML ("<div> <font color='red'>Please be patient for all dots to show. Actually, the 50th dot will be the best city :-) </font> <br>1. Color indicates rank of the city - LOWER VALUE IS BETTER (see the color coding below) 
                                <br>2. Size of dot indicates value of selected Characteristic - LARGER dot is HIGHER value <br>
                              3. You can hover over the dots to know the city and value of the characteristic</div>"),htmlOutput("gvisgeoplot")
         ),
    
    # for scatter plot
    
    tabPanel ("Characteristics and Cities", HTML("<div> <font color='red'>This chart can be played around with in the following ways.</font><br> 
                1. The two small tabs on the top right show either bubble charts or bar graphs, depending on what's selected. <br>
                2. The horizontal and vertical axes can be changed to other variables by clicking at existing axis labels (the arrow mark) <br>
                3. Size of dot indicates Rank of the city - LARGER size is BETTER ranked. (The rank is 51 minus the displayed value. This shows as variable 'RankReordered' in list in the axes.
                  See below the plot for explanation.)<br>
                4. You can hover over the dots to know the city and value of the characteristics<br>
                5. Color is used to identify the city. No other purpose.<br><br></div>"),htmlOutput("scatterplot"),
                HTML("<div><font size=1>Since ranking of 1 is better than 50, the default approach would've placed smaller dots for better ranked cities. 
                So, to have larger bubbles for better cities a reranking was done to have a higher value for better city (51 minus the 'real' rank). 
                         This was done only for this plot.</font></div>")),
    
  tabPanel("Data", htmlOutput("bestcitiesdata")) # viewing data
  
))))