setwd('/app')
library(optparse)
library(jsonlite)



print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--LS"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--RWSbiogeo_station"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--stations"), action="store", default=NA, type="character", help="my description")
)


opt = parse_args(OptionParser(option_list=option_list))

var_serialization <- function(var){
    if (is.null(var)){
        print("Variable is null")
        exit(1)
    }
    tryCatch(
        {
            var <- fromJSON(var)
            print("Variable deserialized")
            return(var)
        },
        error=function(e) {
            print("Error while deserializing the variable")
            print(var)
            var <- gsub("'", '"', var)
            var <- fromJSON(var)
            print("Variable deserialized")
            return(var)
        },
        warning=function(w) {
            print("Warning while deserializing the variable")
            var <- gsub("'", '"', var)
            var <- fromJSON(var)
            print("Variable deserialized")
            return(var)
        }
    )
}

print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)
print("Retrieving LS")
var = opt$LS
print(var)
var_len = length(var)
print(paste("Variable LS has length", var_len))

LS <- gsub("\"", "", opt$LS)
print("Retrieving RWSbiogeo_station")
var = opt$RWSbiogeo_station
print(var)
var_len = length(var)
print(paste("Variable RWSbiogeo_station has length", var_len))

RWSbiogeo_station <- gsub("\"", "", opt$RWSbiogeo_station)
print("Retrieving stations")
var = opt$stations
print(var)
var_len = length(var)
print(paste("Variable stations has length", var_len))

stations <- gsub("\"", "", opt$stations)


print("Running the cell")
print(stations)
print(RWSbiogeo_station)
print(LS)
