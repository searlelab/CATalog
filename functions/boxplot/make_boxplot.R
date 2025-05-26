make_boxplot <- function(df, name, flag){
	plot <- ggplot(df, aes(x = as.factor(biofluid), y = values, fill = biofluid, label = labels))+
		geom_boxplot(outlier.shape = NA)+
		theme(axis.title.x=element_blank(),
		      axis.text.x=element_blank(),
		      axis.ticks.x=element_blank(),
		      axis.title.y = element_text(size = 14),
		      plot.title = element_text(size = 8),
		      legend.title=element_text(size = 14),
		      legend.text=element_text(size = 12))+
		scale_fill_manual(values = c('#D55382', '#003F5C', '#FFA600'))+
		#geom_jitter(color = "black", position = position_jitter(seed = 1, width = 0.2))+
		ylab("Relative Abundance")+
		ggtitle(name)
	if(flag == "off"){
		plot_unannotated <- plot + geom_jitter(color = "black", position = position_jitter(seed = 1, width = 0.2))
		return(plot_unannotated)
	}
	else if(flag == "on"){
		plot_annotated <- plot + geom_text(color = "darkslategrey", position = position_jitter(seed = 1, width = 0.2))
		return(plot_annotated)
	}
}


