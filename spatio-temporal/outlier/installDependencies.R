#Checks if the required packages are installed. If not, install the packages listed

packages <- c("caret","ape","e1071")
for(pkg in packages){
  if(!is.element(pkg, installed.packages()[,1])) {
    install.packages(pkg, repos="http://cran.fhcrc.org")
  } else {print(paste(pkg, " library already installed"))}
}


