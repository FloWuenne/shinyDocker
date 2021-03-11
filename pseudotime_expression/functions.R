## Functions for pseudotime expression app

## modify plotting function from psupertime to plot genes of interest instead of top N
plot_identified_genes_over_psupertime_goi <- function(psuper_obj, 
                                                      label_name='Ordered labels', 
                                                      n_to_plot=20, 
                                                      palette='RdBu', 
                                                      genes_of_interest = c(""),
                                                      scales = "free_y", 
                                                      legend_plot = "show", 
                                                      legend_position = "bottom"){
  
  library(RColorBrewer)
  library(data.table)
  library(ggplot2)
  library(scales)
  library(cowplot)
  
  ## use cowplot theme as default 
  theme_set(theme_cowplot())
  
  # unpack
  proj_dt 	= psuper_obj$proj_dt
  beta_dt 	= psuper_obj$beta_dt
  x_data 		= psuper_obj$x_data
  params 		= psuper_obj$params
  
  # set up data for plotting
  plot_wide 	= cbind(proj_dt, data.table(x_data[, genes_of_interest, drop=FALSE]))
  plot_dt 	= melt.data.table(plot_wide, id=c('psuper', 'label_input', 'label_psuper','cell_id'), variable.name='symbol')
  plot_dt[, symbol := factor(symbol, levels=genes_of_interest)]
  
  # plot
  g =	ggplot(plot_dt) +
    aes( x=psuper, y=value) +
    geom_point( size=2, aes(colour=label_input) ) +
    geom_smooth(se=FALSE, colour='black') +
    scale_colour_brewer(palette = "Dark2") +
    scale_shape_manual( values=c(1, 16) ) +
    scale_x_continuous( breaks=pretty_breaks() ) +
    scale_y_continuous( breaks=pretty_breaks() ) +
    facet_wrap( ~ symbol, scales=scales) +
    guides(colour = guide_legend(nrow = 1,
                                 override.aes = list(size=5))) +
    labs(
      x 		= 'Pseudotime',
      y 		= 'z-scored scaled expression'
      ,colour = label_name
    ) +
    theme(plot.title = element_text(face = "bold"),
          strip.text=element_text(colour="white", face = "bold"), 
          strip.background=element_rect(fill="grey20"),
          axis.title = element_text(color="black", face="bold")) 
  
  if(legend_plot == "hide"){
    g  <- g +
      theme(legend.position = "none")
  }else if (legend_plot == "show"){
    g  <- g +
      theme(legend.position = legend_position,
            legend.title = element_text(color = "black", size = 24),
            legend.text = element_text(color = "black", size = 20))
  }
  
  return(g)
}