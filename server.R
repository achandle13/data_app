cf<-function(upb,rate,freq,term)  {
  rate<-rate/100
  upb/((1-(1/(1+rate/freq)^(freq*term)))/(rate/freq))
}
smm<-function(psa,t,freq) {
  if (t>=30) 
    1-(1-(psa/100)*(.06))^(1/freq)  
  else 
    1-(1-(psa/100)*(t*.002))^(1/freq)
}
usersmm<-function(ppmnt,r,e,c,ppmntconst,t,freq) {
  if (t>=c) 
    1-(1-(ppmntconst/100))^(1/freq)
  else 
    1-(1-(r*(ppmnt/100)^e))^(1/freq)
}

mortg<-function(upb,rate,freq,term,psa,ppmnt,ppmntconst,r,e,c){
  
  amort<-as.data.frame(matrix(data=0,nrow=freq*term,ncol=14,byrow=FALSE))
  colnames(amort)<-c("Begin","Int","Prin","End","Begin2","Int2","Prin2","Prepay2","End2",
                     "Begin3","Int3","Prin3","Prepay3","End3")
  
  begupb<-upb
  begupb2<-upb
  begupb3<-upb
  
  int<-rate/(freq*100)
  pmt<-cf(upb,rate,freq,term)
  
  for (t in seq(from=1,to=freq*term,by=1))
  {
    amort$Begin[t]<-begupb
    amort$Begin2[t]<-begupb2
    amort$Begin3[t]<-begupb3
    
    amort$Int[t]<-int*begupb
    amort$Int2[t]<-int*begupb2
    amort$Int3[t]<-int*begupb3
    
    amort$Prin[t]<-pmt-int*begupb
    amort$Prin2[t]<-min((pmt-int*begupb2),begupb2)
    amort$Prin3[t]<-min((pmt-int*begupb3),begupb3)
    
    prepay<-smm(psa,t,freq)
    prepay2<-usersmm(ppmnt,r,e,c,ppmntconst,t,freq)
    
    amort$Prepay2[t]<-prepay*(begupb2-amort$Prin2[t])
    amort$Prepay3[t]<-prepay2*(begupb3-amort$Prin3[t])
    
    amort$End[t]<-begupb-amort$Prin[t]
    amort$End2[t]<-begupb2-amort$Prin2[t]-amort$Prepay2[t]
    amort$End3[t]<-begupb3-amort$Prin3[t]-amort$Prepay3[t]
    
    begupb<-amort$End[t]
    begupb2<-amort$End2[t]
    begupb3<-amort$End3[t]
    
  }
  
  return(amort)
  
  
  
}


prepay_model <-function(psa){ 
  
  prepay <- as.data.frame(matrix(data=0,nrow=360,ncol=2,byrow=TRUE))
  colnames(prepay)<-c("Base","PSA")
  
  for (i in seq(from=1,to=360,by=1))
    
    if (i < 30)
    {
      prepay$Base[i]<-i*.2
      prepay$PSA[i] <- psa/100*i*.2
    }
  else
  {
    prepay$Base[i] <-6
    prepay$PSA[i] <-psa/100*6
  }
  
  
  return(prepay)
}   

shinyServer(
  function(input,output) {
    
    output$upb <- renderPrint({input$upb})
    output$rate <- renderPrint({input$rate})
    output$term <- renderPrint({input$term})
    output$freq <- renderPrint({input$freq})
    output$cf <- renderPrint({cf(input$upb,input$rate,input$freq,input$term)})
    output$model <- renderPlot({
      prepay<-prepay_model(input$psa2)
      plot(prepay$PSA,type="l",col=c("black"),xlab="Loan Age (Months)",
           ylab="Annualized Rate (%)",main="Prepayment Model")
      par(new=TRUE)
      lines(prepay$Base,type="l",col=c("red"))
      legend("bottomright",inset=.05,legend=c("PSA","Base"),lty=1,col=c("Black","Red"))
          })
    
    
    
    
    
    
  }
)
