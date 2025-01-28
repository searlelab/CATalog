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
source('./functions/mapping/map_row_index_to_entry_id.R')
source('./functions/mapping/map_biofluid_to_column_index.R')
source('./functions/mapping/map_row_index_to_protein_name.R')
source('./functions/mapping/map_row_index_to_gene.R')

#boxplot functions
print("loading boxplot functions")
source('./functions/boxplot/boxplot_driver.R')
source('./functions/boxplot/format_boxplot_data.R')
source('./functions/boxplot/make_boxplot.R')

#scatterplot functions
print("loading scatterplot functions")
source('./functions/scatterplot/format_demographics.R')
source('./functions/scatterplot/format_subframe.R')
source('./functions/scatterplot/make_scatterplot.R')
source('./functions/scatterplot/scatterplot_driver.R')

#gene ontology functions
print("loading GO functions")
source('./functions/gene_ontology/go_processor.R')
source('./functions/gene_ontology/parse_cell.R')
source('./functions/gene_ontology/set_ontology.R')
source('./functions/gene_ontology/spoof_dataframe.R')
source('./functions/gene_ontology/combine_go_dataframes.R')
source('./functions/gene_ontology/inject_go_types.R')

#search-reated functions
print("loading search functions")
source('./functions/search/search_for_go_keyword.R')
source('./functions/search/search_for_protein.R')


#filtering functions
print("loading filter functions")
source('./functions/filters/apply_demographic_filter.R')
source('./functions/filters/filter_background_by_demographics.R')
source('./functions/filters/filter_background_by_cache.R')
source('./functions/filters/filter_foreground_by_highest_biofluid.R')
source('./functions/filters/update_demographics.R')

#shopping cart functions
print("loading shopping cart functions")
#source('./functions/shopping_cart/add_multiple_rows_to_cart.R')
#source('./functions/shopping_cart/add_row_to_cart.R')
source('./functions/shopping_cart/create_empty_dataframe.R')
source('./functions/shopping_cart/remove_row_from_cart.R')
source('./functions/shopping_cart/get_selected_rows.R')
#source('./functions/shopping_cart/create_empty_go_dataframe.R')

##components

#rendering
print("loading rendering components")
source('./components/rendering/shopping_cart_display_backend.R')
source('./components/rendering/shopping_cart_display_frontend.R')
source('./components/rendering/render_plot_display.R')
source('./components/rendering/render_demographic_table.R')
source('./components/rendering/render_go_table.R')
source('./components/rendering/render_main_display_table.R')

#buttons
print("loading button components")
source('./components/buttons/filter_button_logic.R')
source('./components/buttons/search_button_logic.R')
source('./components/buttons/reset_button_logic.R')
source('./components/buttons/add_element_button_logic.R')
source('./components/buttons/remove_cart_item_button_logic.R')
source('./components/buttons/show_cart_button_logic.R')

#toggles
print("loading toggle components")
source('./components/toggles/toggle_annotations.R')
source('./components/toggles/toggle_go_data_type.R')
source('./components/toggles/toggle_plot_type.R')

#event handlers
print("loading event handlers")
source('./components/event_handlers/main_display_row_click_handler.R')

#error handlers
print("loading error handlers")
source('./components/error_handlers/invalid_demographic_value_error_handler.R')

#download handlers
print("loading download handlers")
source('./components/download_handlers/download_protein_handler.R')
source('./components/download_handlers/download_go_handler.R')

#setup
print("loading setup sequence")
source('./components/setup/database_setup.R')

