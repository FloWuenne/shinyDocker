## This app let's users select a cell-type and a gene of interest and will plot its expression over pseudotime

library(shiny)
library(reactable)
library(data.table)

# List of genes for user selection
table_s3 <- fread("./Table_S3.tsv", fill = TRUE)
table_s3 <- subset(table_s3,!is.na(avg_log2FC))
cell_types <- sort(unique(table_s3$cell_type))

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    titlePanel(""),
    
    # Sidebar with a slider input for number of bins
    
    fluidRow(
        column(width = 2,
               h2("Control panel:"),
               br(),
               selectizeInput("celltype_selected",
                              label = "Select your cell-type of interest",
                              choices = cell_types,
                              selected = cell_types[1]),
               br(),
               uiOutput("gene_selection"),
               ),
        
        column(width = 8,
               h2("Expression plot over pseudotime"),
               plotOutput("pseudotime_plot"),
               ),
        
        
    ),
    
    fluidRow(wdith =12,
             h2("Results table from GAM analysis on gene expression (Table S3)"),
             reactableOutput("celltype_table")
             )

    )
)
