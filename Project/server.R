source("helper.R")
library(shiny)
library(rCharts)
library(reshape2)
library(UsingR)
data(galton)
library(rmongodb)

shinyServer(
	function(input,output){

	newEntry <- reactive({
		if(input$action > 0){
		if(input$gender==1){male=1}else{male=0}
		if(input$smokerornot==1){currentSmoker=1}else{currentSmoker=0}
		if(input$BPMeds==1){BPMeds=1}else{BPMeds=0}
		if(input$Stroke==1){prevalentStroke=1}else{prevalentStroke=0}
		if(input$Hyp==1){prevalentHyp=1}else{prevalentHyp=0}
		if(input$diabetes==1){diabetes=1}else{diabetes=0}
		isolate(data.frame(male,
						   age = input$age,  
						   currentSmoker,
						   cigsPerDay = input$cigsPerDay,
							BPMeds,
							prevalentStroke,
							prevalentHyp,
							diabetes,
							totChol = input$totChol,
							sysBP = input$sys,
							diaBP = input$dia,
							BMI = input$BMI,
							heartRate = input$heartRate,
							glucose = input$glucose
							))
		}
	})
	

	output$table <- renderTable({
		if(!is.null(newEntry())) 
		{data <- newEntry()
		Pramater = c("Gender", "Age", "Current Smoker", "Cigs/Day", 
					"Anti-hypertensive medicine", "Stroke history", "Hypertensive history",
					"Diabetes", "Cholesterol", "Systolic BP", "Diastolic BP","BMI", "Heart rate", "Glucose")
		if(data$male==1){sex="Male"}else(sex="Female")
		if(data$currentSmoker==1){smok="Yes"}else(smok="No")
		if(data$BPMeds==1){bpmed="Yes"}else(bpmed="No")
		if(data$prevalentStroke==1){str="Yes"}else(str="No")
		if(data$prevalentHyp==1){hyp="Yes"}else(hyp="No")
		if(data$diabetes==1){dia="Yes"}else(dia="No")
		Value = c(sex, data$age, smok, data$cigsPerDay, bpmed, str, hyp, dia, data$totChol, 
				data$sysBP, data$diaBP, data$BMI, data$heartRate, data$glucose)
		
		cbind(Pramater, Value)}

		})
	
	output$prediction <- renderText({
		if(is.null(newEntry())) {return()}
		prediction <- predict(model, newEntry(), type="response")
		pred = round(prediction, 4)
		pred = sprintf("%.2f%%", 100*pred)
		paste("You have ", pred, " of risk to have coronary heart disease in the next 10 years.")
		})
	
	output$plot_BMI <- renderChart({
		plot = plotBMI()
		plot$xAxis(axisLabel = "Age")
		plot$yAxis(axisLabel = "Mean Body Mass Index", width = 40)
		plot$addParams(dom = "plot_BMI")
		return(plot)
		})
	
		
	#######     DATABASE       ###########################
	options(mongodb = list(
				"host" = "myhost",
				"username" = "admin",
				"password" = "secrete"
				))
	databaseName <- "shinydatabase"
	collectionName <- "shinydatabase.collection"
	
	saveData <- function(data) {

			data <- newEntry()
			pred <- predict(model, data, type="response")
			result <- function(){if(pred>0.5){1}else{0}}
			data[,"TenYearCHD"] <- result()
			#data[,"tenyear"] <- 1
			db <- mongo.create(db = databaseName, host = options()$mongodb$host, 
			username = options()$mongodb$username, password = options()$mongodb$password)
			update <- mongo.bson.from.list(as.list(data))
			mongo.insert(db, collectionName, update)
			mongo.disconnect(db)
		}
		
	observeEvent(input$action, 
				{
				saveData()})
	
	loadData <- function() {
			
			db <- mongo.create(db = databaseName, host = options()$mongodb$host, 
			username = options()$mongodb$username, password = options()$mongodb$password) 
			if (mongo.is.connected(db))
			{data <- mongo.find.all(db, collectionName)
			data <- lapply(data, data.frame, stringsAsFactors = FALSE)  
			data <- do.call(rbind, data)
			data <- data[ , -1, drop = FALSE]
			mongo.disconnect(db)
			data}
		}
		
	 output$responses <- renderDataTable({
					#input$action 
					loadData()
		})     
})

