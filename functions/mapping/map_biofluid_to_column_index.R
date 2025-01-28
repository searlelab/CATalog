map_biofluid_to_column_index <- function(target) {
  index <- switch(target,
                  "Urine" = 4,
                  "Serum" = 5,
                  "Plasma" = 6,
                  NULL)  # Default value if no match
  return(index)
}
