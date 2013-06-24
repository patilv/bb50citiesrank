
library("shiny")
suppressPackageStartupMessages(library(googleVis))
library("ggplot2")

#loading dataset
load('bcities.rda')

SP <- list() # # Hit counter, Courtesy: Francis Smart: http://www.econometricsbysimulation.com/2013/06/more-explorations-of-shiny.html
SP$npers <- 0

shinyServer(function(input, output) {
  
  # An increment to the hit counter saved in global server environment.
  SP$npers <<- SP$npers+1
  

  # Convenience interface to gvisMotionChart that allows to set default columns: Courtesy: Sebastian Kranz: http://stackoverflow.com/questions/10258970/default-variables-for-a-googlevis-motionchart
  myMotionChart = function(df,idvar=colnames(df)[1],timevar=colnames(df)[2],xvar=colnames(df)[3],yvar=colnames(df)[4], colorvar=colnames(df)[5], sizevar = colnames(df)[6],...) {
    library(googleVis)
    
    # Generate a constant variable as column for time if not provided
    # Unfortunately the motion plot still shows 1900...
    if (is.null(timevar)) {
      .TIME.VAR = rep(0,NROW(df))
      df = cbind(df,.TIME.VAR)
      timevar=".TIME.VAR"
    }
    
    # Transform booleans into 0 and 1 since otherwise an error will be thrown
    for (i in  1:NCOL(df)) {
      if (is.logical(df [,i])[1])
        df[,i] = df[,i]*1
    }
    
    # Rearrange columns in order to have the desired default values for
    # xvar, yvar, colorvar and sizevar
    firstcols = c(idvar,timevar,xvar,yvar,colorvar,sizevar)
    colorder = c(firstcols, setdiff(colnames(df),firstcols))
    df = df[,colorder]
    
    gvisMotionChart(df,idvar=idvar,timevar=timevar,...)
  }
  
  #  creating temp dataset with two new variables
 
  Bcities<-bcities
  
  #Adding a column for the year: Why? see tab 2 discussion below
  Bcities$Year<-c("2012")
  Bcities$Year<-as.numeric(Bcities$Year)
  
  #New variable which converts ranks from 1 through 50 to 50 through 1....why? see tab 2 discussion below
  Bcities$RankReordered<-(51-Bcities$Rank)
  
  #Output for hits
  output$hits <- renderText({
    paste0("App Hits:" , SP$npers)
  })
  
  
  #Output for tab 1 - geo chart
  output$gvisgeoplot <- renderGvis({
    gvisGeoChart(Bcities,locationvar="City",colorvar="Rank",sizevar=input$var1,
                 hovervar="City",
                 options=list(region="US",displayMode="markers",resolution="provinces",
                              colorAxis="{colors:['blue', 'green', 'yellow','orange','red']}",
                              width=640,height=480)
                              )
                                  })
  #output for tab 2 - okay, using a motion chart and modifying code to show scatter plots instead.AND YES, THIS COULD'VE BEEN DONE WITHOUT THE SHINY SERVER
  # Here the column with value of 2012 is used as the time variable, and because its constant, there's no motion.
  # The size of bubbles could've been the same, but figured sizing them based on rank might be better. 
  # Since ranking of 1 is better than 50, the size var would've placed smaller dots for better ranks. 
  #So, have it give larger bubbles for better cities by creating the new "Rankreordered" variable.
  
  output$scatterplot <- renderGvis({
    myMotionChart(Bcities, idvar="City", timevar="Year",xvar="Percent.unemployed",yvar="Percent.with.Graduate.Degree",sizevar="RankReordered",colorvar="City",
                    options=list(showSidePanel=FALSE,showSelectListComponent=FALSE,showXScalePicker=FALSE,
                                 showYScalePicker=FALSE
                                 
                                 ))})
 
  #Output table for tab 3 # going back to the original dataset, without the two temp vars created
  output$bestcitiesdata <- renderGvis({
    gvisTable(bcities)})
  
                 })
  
