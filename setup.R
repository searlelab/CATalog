#dependencies
library(shiny)
library(DT)
library(ggplot2)
library(shinydashboard)
library(tidyverse)

#static datasets
go_data <- read.csv("./data/go_data.csv")
demographics <- read.csv("./data/demographics.csv")

#loading functions
source('./functions/loading/generate_foreground.R')

#mapping_functions
source('./functions/mapping/map_entry_to_index.R')
source('./functions/mapping/map_target_to_index.R')

#boxplot functions
source('./functions/boxplot/boxplot_driver.R')
source('./functions/boxplot/format_data.R')
source('./functions/boxplot/make_boxplot_annotated.R')
source('./functions/boxplot/make_boxplot_unannotated.R')

#gene ontology functions
source('./functions/gene_ontology/go_processor.R')
source('./functions/gene_ontology/parse_cell.R')
source('./functions/gene_ontology/set_ontology.R')
source('./functions/gene_ontology/spoof_dataframe.R')

#search-reated functions
source('./functions/search/search_for_go_keyword.R')
source('./functions/search/go_column_mapper.R')

#filtering functions
source('./functions/filters/apply_demographic_filter.R')
source('./functions/filters/filter_background.R')
source('./functions/filters/filter_background_by_cache.R')
source('./functions/filters/filter_foreground.R')

#components
source('./components/annotation_toggle.R')
source('./components/filter_handler.R')
source('./components/reset_handler.R')
source('./components/row_click_handler.R')
source('./components/search_handler.R')

