inject_go_types <- function(go_list) {
    # Assign initial names to avoid re-indexing issues
    names(go_list) <- c("bioprocess", "cellcompartment", "molfunction")
    
    # Remove data frames with 0 rows
    go_list <- Filter(function(df) nrow(df) > 0, go_list)
    
    # Inject types only to the retained elements
    if ("bioprocess" %in% names(go_list)) {
        go_list[["bioprocess"]]$type <- "biological process"
    }
    if ("cellcompartment" %in% names(go_list)) {
        go_list[["cellcompartment"]]$type <- "cellular compartment"
    }
    if ("molfunction" %in% names(go_list)) {
        go_list[["molfunction"]]$type <- "molecular function"
    }
    
    print("Successfully injected GO types")
    return(go_list)
}
