inject_go_types <- function(go_list) {
    names(go_list) <- c("bioprocess", "cellcompartment", "molfunction")
    go_list <- Filter(function(df) nrow(df) > 0, go_list)
    
    if ("bioprocess" %in% names(go_list)) {
        go_list[["bioprocess"]]$type <- "Biological Process"
    }
    if ("cellcompartment" %in% names(go_list)) {
        go_list[["cellcompartment"]]$type <- "Cellular Compartment"
    }
    if ("molfunction" %in% names(go_list)) {
        go_list[["molfunction"]]$type <- "Molecular Function"
    }   
    return(go_list)
}
