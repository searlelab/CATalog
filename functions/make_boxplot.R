make_boxplot <- function(df, name){
	plot <- ggplot(df, aes(x = as.factor(group), y = values, fill = group, label = labels))+
		geom_boxplot()+
		geom_jitter(color = "blue", position = position_jitter(seed = 1))+
		geom_text(position = position_jitter(seed = 1))+
		xlab("sample")+
		ggtitle(name)
	plot
}

