make_boxplot <- function(df, name){
	plot <- ggplot(df, aes(x = as.factor(group), y = values, fill = group, label = labels))+
		geom_boxplot()+
		theme(axis.title.x=element_blank(),
		      axis.text.x=element_blank(),
		      axis.ticks.x=element_blank())+
		scale_fill_manual(values = c('#D55382', '#003F5C', '#FFA600'))+
		#geom_jitter(color = "cyan4", position = position_jitter(seed = 1))+
		geom_text(color = "cyan4", position = position_jitter(seed = 1))+
		ylab("relative intensity")+
		ggtitle(name)
	plot
}


