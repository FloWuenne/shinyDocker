#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(reactable)
library(data.table)

source("./functions.R")
table_s3 <- fread("./Table_S3.tsv")
table_s3 <- subset(table_s3,!is.na(avg_log2FC))
#source("./pseudotime_expression/functions.R")

## Test psupertime object
#psuper_obj <- readRDS("../data/Valvular_endothelial_cells.rds")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    subset_table_s3 <- reactive({
        req(input$celltype_selected)
        genes_available <- subset(table_s3,cell_type == input$celltype_selected)
        return(genes_available)
    })
    
    output$gene_selection <- renderUI({
        req(input$celltype_selected)
        req(subset_table_s3())
        genes_available <- unique(subset_table_s3()$gene)
        genes_available <- gsub("-",".",genes_available)
        selectizeInput("gene_selected",
                       label = "Select your gene of interest",
                       choices = genes_available,
                       selected = genes_available[1])
    })
    
    pseudotime_object <- reactive({
        psuper_obj <- readRDS(paste("/home/",Sys.getenv("USERNAME"),"/pseudotime_data/",input$celltype_selected,".rds",sep=""))
    })

    output$pseudotime_plot <- renderPlot({
        req(pseudotime_object())
        req(input$gene_selected)
        plot_identified_genes_over_psupertime_goi(pseudotime_object(), 
                                                  label_name='Age',
                                                  palette = "Dark2", 
                                                  genes_of_interest = input$gene_selected,
                                                  scales = "free_y", 
                                                  legend_plot = "show", 
                                                  legend_position = "bottom")
        
    })
    
    output$celltype_table <- renderReactable({
        req(subset_table_s3())
        reactable(subset_table_s3(),
                  filterable = TRUE,
                  searchable = TRUE,
                  minRows = 10)
    })

})
