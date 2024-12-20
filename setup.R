#dependencies
library(shiny)
library(DT)
library(ggplot2)
library(shinydashboard)
library(tidyverse)
library(shinyalert)
library(shinyjs)

#static datasets
print("loading datasets")
go_data <- read.csv("./data/go_data.csv")
demographics <- read.csv("./data/demographics.csv")

#loading functions
print("loading setup functions")
source('./functions/loading/generate_foreground.R')

#mapping_functions
print("loading mapping functions")
source('./functions/mapping/map_entry_to_index.R')
source('./functions/mapping/map_target_to_index.R')

#boxplot functions
print("loading plotting functions")
source('./functions/boxplot/boxplot_driver.R')
source('./functions/boxplot/format_data.R')
source('./functions/boxplot/make_boxplot.R')

#gene ontology functions
print("loading GO functions")
source('./functions/gene_ontology/go_processor.R')
source('./functions/gene_ontology/parse_cell.R')
source('./functions/gene_ontology/set_ontology.R')
source('./functions/gene_ontology/spoof_dataframe.R')

#search-reated functions
print("loading search functions")
source('./functions/search/search_for_go_keyword.R')
source('./functions/search/search_for_protein.R')


#filtering functions
print("loading filter functions")
source('./functions/filters/apply_demographic_filter.R')
source('./functions/filters/filter_background.R')
source('./functions/filters/filter_background_by_cache.R')
source('./functions/filters/filter_foreground.R')
source('./functions/filters/update_demographics.R')

#shopping cart functions
print("loading shopping cart functions")
source('./functions/shopping_cart/add_multiple_rows_to_cart.R')
source('./functions/shopping_cart/add_row_to_cart.R')
source('./functions/shopping_cart/create_empty_dataframe.R')
source('./functions/shopping_cart/remove_row_from_cart.R')
source('./functions/shopping_cart/get_selected_rows.R')

##components

#rendering
print("loading rendering components")
source('./components/rendering/protein_cart_main_display_backend.R')
source('./components/rendering/render_main_display_table.R')

#buttons
print("loading button components")
source('./components/buttons/filter_button_logic.R')
source('./components/buttons/search_button_logic.R')
source('./components/buttons/reset_button_logic.R')

#toggles
print("loading toggle components")
source('./components/toggles/toggle_annotations.R')
source('./components/toggles/toggle_go_data_type.R')

#event handlers
print("loading event handlers")
source('./components/event_handlers/add_protein_to_shopping_cart_handler.R')
source('./components/event_handlers/main_display_row_click_handler.R')
source('./components/event_handlers/remove_protein_from_shopping_cart_handler.R')
source('./components/event_handlers/shopping_cart_row_click_handler.R')

#error handlers
print("loading error handlers")
source('./components/error_handlers/invalid_demographic_value_error_handler.R')

