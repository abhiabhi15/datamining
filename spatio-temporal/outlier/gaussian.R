### To generate model, which computes covaraince, mean and proportion 
gaussian <- function(data, label){
    names(data)[label] = "label"
    n <- length(unique.default(data$label))
    model <- list()
    
    for(i in 1:n){
        tmp <- data[data$label == i,-c(label)]
        covM <- cov(tmp)  ## Covariance Matrix
        meanV <- as.vector(colMeans(tmp))  ## Mean Vector
        prop <- nrow(tmp)/nrow(data)  ## Class Label Proportion
        item <- list()
        item$cov <- covM
        item$mean <- meanV
        item$prop <- prop
        model[[i]] <- item
    }
    model
}

## Predict Function for newData
# @model model in which covariance, mean and proportion is computed
# @newdata testdata
# @method either discriminant function or probability function
# @classification mlc => maximum likelihood classification , map => maximum a posteriori
##
predictGauss <- function(model, newdata, method="discriminant", classification="mlc"){

    labels <- length(model)
    ## function to get discriminant function of Gaussian Multivariate Distribution
    discrimant <- function(x, model, classification){
        d <- length(x)
        covM <- model$cov
        meanV <- model$mean
        mat <- as.matrix(x - meanV)
        comp1 <- -0.5 * (t(mat) %*% solve(covM) %*% mat)
        comp2 <- ((-d/2) *log(2 * pi)) - (0.5 * log(det(covM)))
        val <- comp1 + comp2
        if(classification == "map"){ ## Adding Class Proportion if "map" is set
            val = val + log(model$prop)
        }
        val
    }
    
    ## function to get probability function of Gaussian Multivariate Distribution
    prob <- function(x, model, classification){
        d <- length(x)
        covM <- model$cov
        meanV <- model$mean
        mat <- as.matrix(x - meanV)
        comp1 <- exp(-0.5 * (t(mat) %*% solve(covM) %*% mat))
        comp2 <- 1/sqrt(((2 * pi)^d) *det(covM))
        val <- comp1 * comp2
        if(classification == "map"){ ## Multiplication with Class Proportion if "map" is set
            val = val * model$prop
        }
        val
    }
        
    output <- c()
    for(i in 1:labels){
        label_model <- model[[i]]
        if(method == "discriminant"){
            V <- apply(newdata, 1,FUN=discrimant, model=label_model, classification)
            output <- cbind(output, V)    
        }else if(method == "probability"){
            V <- apply(newdata, 1,FUN=prob, model=label_model, classification)
            output <- cbind(output, V)
        }
    }
    ##print(head(output))
    ## Selecting the maximum label class
    output = apply(output, 1, which.max)
    output    
}
