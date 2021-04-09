## This app let's users select a cell-type and a gene of interest and will plot its expression over pseudotime

library(shiny)
library(reactable)
library(data.table)

# List of genes for user selection
table_s3 <- fread("./Table_S3.tsv", fill = TRUE)
cell_types <- sort(unique(table_s3$cell_type))

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    titlePanel(""),
    
    # Sidebar with a slider input for number of bins
    fluidRow(column(width = 6, align="center",
                            h2("Control panel:"),
                            br(),
                            selectizeInput("celltype_selected",
                                           label = "Select your cell-type of interest",
                                           choices = cell_types,
                                           selected = cell_types[1],
                                           width = "100%"),
                            br(),
                            uiOutput("gene_selection")
                    ),
    
    column(width = 6, align="center",
           plotOutput("umap_trajectory"))
    ),
    
    
    fluidRow(
        column(width = 12,align="center",
               h2("Expression plot over pseudotime"),
               plotOutput("pseudotime_plot"),
               ),
        
        
    ),
    
    br(),
    br(),
    
    fluidRow(wdith =12,
             h2("Results table from GAM analysis on gene expression (Table S3)"),
             p("Legend: 
             t_exp_fit_max = Relative pseudotime at maximum GAM fit,
             t_exp_fit_min = Relative pseudotime at minimum GAM fit,
             dt_max_fit = absolute pseudotime difference between min and max GAM fit, 
             dexp_fit_t = difference between GAM fit at beginning (t0) and end (t1) of trajectory, 
             dexp_fit_max = difference between max value and min expression GAM fit, 
             pvalue = p-value from generalized additive models (GAM), 
             gene = tested gene symbol,
             FDR = Benjamini-Hochberg (FDR) corrected p-values"),
             reactableOutput("celltype_table")
             )
    												
    

    )
)
