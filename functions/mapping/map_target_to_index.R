map_target_to_index <- function(target) {
  index <- switch(target,
                  "urine" = 4,
                  "serum" = 5,
                  "plasma" = 6,
                  NULL)  # Default value if no match
  return(index)
}
