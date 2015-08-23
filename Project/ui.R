library(shiny)
library(rCharts)
library(reshape2)


shinyUI(
	fluidPage(
		titlePanel("Heart Disease Prediction" ),
		
		
		sidebarPanel(
		numericInput("age", "1. Your Age", 0, min=0, max=100),
		
		radioButtons("gender", label = strong("2. Gender"), 
		choices = list("Male" = 1, "Female" = 0), selected = 1),
		
		radioButtons("smokerornot", label = strong("3. Are you a current smoker?"), 
		choices = list("Yes" = 1, "No" = 0), selected = 1),
		
		numericInput("cigsPerDay", "4. How many cigarettes do you smoke every day?", 0, min=0, max=100),
		
		radioButtons("BPMeds", label = strong("5. Do you take anti-hypertensive medication now?"), 
		choices = list("Yes" = 1, "No" = 0), selected = 1),
		
		radioButtons("Stroke", label = strong("6. Did you have stroke before?"), 
		choices = list("Yes" = 1, "No" = 0), selected = 1),
		
		radioButtons("Hyp", label = strong("7. Did you have hypertensive before?"), 
		choices = list("Yes" = 1, "No" = 0), selected = 1),
		
		radioButtons("diabetes", label = strong("8. Do you have diabetes?"), 
		choices = list("Yes" = 1, "No" = 0), selected = 1),
		
		sliderInput("totChol", label = strong("9. Serum total cholesterol (mg/dL)"),
        min = 100, max = 800, value = 100),
		
		numericInput("sys", "10. Your systolic blood pressure (mmHg)", 80, min=60, max=300),
		
		numericInput("dia", "11. Your diastolic blood pressure (mmHg)", 80, min=20, max=180),
		
		sliderInput("BMI", label = strong("12. Your body mass index (weight in kilograms/height meters squared)"), min = 15, max = 35, value = 10, step = 0.01),
		
		numericInput("heartRate", "13. Your heart rate (beats/min)", 80, min=30, max=250),
		
		sliderInput("glucose", label = strong("14. Your serum glucose (mg/dL)"),
        min = 30, max = 500, value = 30),
		
		actionButton("action", label = "Submit")
		),
		
		mainPanel(
			tabsetPanel(type = "pills", 
				tabPanel("Result", 
						br(), 
						h4("Your information"),
						br(),
						tableOutput("table"),
						verbatimTextOutput("prediction")),
				tabPanel(p(icon("line-chart"), "Visualization"), 
						h4("Mean Body Mass Index by Age", align = "center"),
						showOutput("plot_BMI", "nvd3")
						),
				tabPanel("Data Set",
						br(),
						dataTableOutput("responses")),
				tabPanel("Introduction", 
						br(),
						p("This risk assessment tool uses information from the Framingham Heart Study to predict a person't chance of having a heart attack in the next 10 years."),
						br(),
						p("Training data is from edX 'The Analytics Edge'. I use the API to collect  and storage data. This service is provided by MongoLab.")
						)
			)
		)
	))