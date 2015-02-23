makeCacheMatrix <- function(m = matrix()) {
      inv.m <- NULL             ## empty inverse matrix of `m` 
      set <- function(A) {
            m <<- A           ## "placeholder" to reassing the value of new matrix `A` (if we want) ##
                              ## `<<-` sings that the variable is defined outside this environment (not only local variable) ##
            inv.m <<- NULL   ## detto ##
      }
      get <- function() m
      setInv <- function(solve) inv.m <<- solve     ## set function to assign a value if cacheSolve is called
      getInv <- function() inv.m    ## if `cacheSolve` was called than assign value of inverse matrix ##
      list(set = set, get = get,    ## create a list of all functions in `makeCacheMatrix` ###
           setInv = setInv,
           getInv = getInv)
}

cacheSolve <- function(m, ...) {
      inv.m <- m$getInv
      if(!is.na(inv.m)) {        ## R checks the condition if there is a value of inverse matrix yet
            message("getting cached data") # and if the condition is TRUE than show message and return that value
            return(inv.m) ## return value of inv.m if the condition is TRUE ## 
      }
      new_matrix <- m$get ## For the first time calling the `cacheSolve`function it's calculate inverse matrix of 'special matrix'. 
      inv.m <- solve(new_matrix, ...) # If there were changes in previous matrix via m$set and previous condition was FALSE
                                        # than calculates inverse matrix again ## 
      m$setInv(inv.m) ## sets the new value of inversion matrix to the m$setInv via `setInv` function  
                        ## NOTE: this can be done because of lexical scoping and using `<<-`superassingment operator
      return(inv.m)       ## return value of `inv.m` 
}
