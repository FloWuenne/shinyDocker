# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny-verse:4.0.4

# system libraries of general use
## install debian packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    libcairo2-dev \
    libsqlite3-dev \
    libpq-dev \
    libssh2-1-dev \
    unixodbc-dev \
    libcurl4-openssl-dev \
    libssl-dev
    
## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

RUN apt-get install -y git 

# clone git repo
## Add an argument to be able to build container from here when git repo changed
ARG DUMMY_ARG=unknown

## Clone github repo
RUN git clone https://github.com/FloWuenne/shinyDocker.git
WORKDIR "./shinyDocker"

# install renv & restore packages
RUN Rscript -e 'install.packages("renv")'
RUN Rscript -e 'renv::consent(provided = TRUE)'
RUN Rscript -e 'renv::restore()'

# expose port
EXPOSE 3838

# run app on container start
CMD ["R", "-e", "shiny::runApp('./pseudotime_expression', host = '0.0.0.0', port = 3838)"]
