shinyUI(pageWithSidebar(
  headerPanel("Mortgage Product Calculator"),
  sidebarPanel(
    
    h2('Mortgage Inputs'),
  
    numericInput('upb','Mortgage Size ($)',150000,min=0,max=1000000,step=250),
    numericInput('rate','Mortgage Rate (%)',6,min=0,max=100,step=.05),
    numericInput('term','Mortgage Term',30,min=.083,max=40,step=1),
    numericInput('freq','Payment Frequency',12,min=1,max=365,step=1),
    
    h2('Benchmark Prepayment Analysis'),
    numericInput('psa','Benchmark Prepayment Speed Assumption (%)',100,min=0,max=10000,step=1),
    
    sliderInput('psa2','Change Benchmark PSA',value=150,min=0,max=1000,step=1),
    
    h2('User Defined Prepayment'),
    numericInput('ppmnt','Conditional Prepayment Rate (%)',.2,min=0,max=100,step=1),
    numericInput('r','Linear Ramp Up/Down',1,min=1,max=100,step=1),
    numericInput('e','Exponential Ramp Up/Down',1,min=.01,max=100,step=1),
    numericInput('c','Set Constant Period',0,min=0,max=365,step=1),
    numericInput('ppmntconst','Set Constant Prepay Rate',0,min=0,max=100,step=1),
    
    submitButton('Submit')
  ),
  mainPanel(
    
    h3("The mortgage product characteristics:"),
    h5("Mortgage Balance:"),
    verbatimTextOutput("upb"),
    h5("Interest Rate:"),
    verbatimTextOutput("rate"),
    h5("Payment Frequency:"),
    verbatimTextOutput("freq"),
    h5("Mortgage Term:"),
    verbatimTextOutput("term"),
    h3("The monthly payment is:"),
    verbatimTextOutput("cf"),
    plotOutput("model")
    
  )
))