inject_go_types <- function(go_list){
	go_list[[1]]$type <- "biological process"
	go_list[[2]]$type <- "cellular compartment"
	go_list[[3]]$type <- "molecular function"
	return(go_list)
}
