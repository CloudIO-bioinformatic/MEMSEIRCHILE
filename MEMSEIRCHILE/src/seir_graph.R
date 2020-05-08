library(ggplot2)
geom.text.size = 7
theme.size = (14/5) * geom.text.size
test <- read.delim("Huechuraba_ejemplo.txt",header=TRUE,sep="\t")
test2 <- read.delim("qHuechuraba_ejemplo.txt",header=TRUE,sep="\t")
max_I <- max(test$I)
day_I <- test[which(test$I==max_I),]$day
max_qI <- max(test2$I)
day_qI <- test2[which(test2$I==max_qI),]$day

png("Huechuraba.png", width=1600,height=900,units="px")

ggplot(test)+
geom_line(size=1,aes(x=day,y=S,color="Susceptibles"))+
geom_line(size=1,data=test,aes(x=day,y=E,color="Expuestos"))+
geom_line(size=1,data=test,aes(x=day,y=I,color="Infectados"))+
geom_line(size=1,data=test,aes(x=day,y=R,color="Recuperados"))+
geom_line(size=1,linetype="dotted",data=test2,aes(x=day,y=S,color="Susceptibles Q"))+
geom_line(size=1,linetype="dotted",data=test2,aes(x=day,y=E,color="Expuestos Q"))+
geom_line(size=1,linetype="dotted",data=test2,aes(x=day,y=I,color="Infectados Q"))+
geom_line(size=1,linetype="dotted",data=test2,aes(x=day,y=R,color="Recuperados Q"))+
scale_color_manual(values = c('Susceptibles' = 'blue', 'Expuestos' = 'red', 'Infectados' = 'green', 'Recuperados'='yellow','Susceptibles Q' = 'darkblue', 'Expuestos Q' = 'darkred', 'Infectados Q' = 'darkgreen', 'Recuperados Q'='orange'))+
labs(title='Gráfico modelo matemático SEIR en Huechuraba, alpha = 0.4, R0 = 2.35',x='Tiempo (días)',y='Población (número de habitantes en la comuna)',colour= "Parámetros")+
guides(colour = guide_legend(override.aes = list(linetype = c(1,4,1,4,1,4,1,4))))+ 
scale_y_continuous(limits = c(0, 115000), breaks = seq(0, 115000, by = 2500))+ 
scale_x_continuous(limits = c(0, 370), breaks = seq(0, 370, by = 10))+theme(legend.key.size =  unit(0.5, "in"))+
theme(plot.title = element_text(hjust = 0.5))+
geom_point(color='black',size=2,aes(x=day_I,y=max_I))+geom_label(
    label=paste(paste(round(max_I)," infectados"),paste(" en el día ",day_I)), 
    x=day_I,
    y=max_I+(max_I*0.3),
    label.padding = unit(0.20, "lines"), # Rectangle size around label
    label.size = 0.14,
    color = "black"
  )+
theme(plot.title = element_text(hjust = 0.5))+
geom_point(color='black',size=2,aes(x=day_qI,y=max_qI))+geom_label(
    label=paste(paste(round(max_qI)," infectados"),paste(" en el día ",day_qI)), 
    x=day_qI+10,
    y=max_qI+(max_I*0.3),
    label.padding = unit(0.20, "lines"), # Rectangle size around label
    label.size = 0.14,
    color = "black"
  )+
theme(axis.title.x = element_text(vjust=-0.5, colour="black", size=rel(1.5))) +
theme(axis.title.y = element_text(vjust=1.5, colour="black", size=rel(1.5)))+
theme (axis.text.x = element_text(colour="black", size=rel(1.5)),axis.text.y = element_text(colour="black", size=rel(1.5), hjust=0.5))+
guides(shape = guide_legend(override.aes = list(size = 5)))

dev.off()






#geom_segment(aes(x = day_I, y = 0, xend = day_I, yend = max_I))+
#geom_segment(aes(x = 0, y = max_I, xend = day_I, yend = max_I))+




#+theme(axis.line = element_line(size = 3, colour = "grey80"),panel.background = element_rect(fill = "white", colour = "grey50"),legend.box.background = element_rect(),legend.box.margin = margin(6, 6, 6, 6))



