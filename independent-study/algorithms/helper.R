## Compare Modularity of different Community Detection Algos
compareModularity <- function(g){
  cat("Modularity Comparison of Graph : #Nodes = ", vcount(g) , " #Edges = ", ecount(g), "\n")
      #c1 <- edge.betweenness.community(g)
      #cat("Edge Betweenness = ", modularity(c1) ,"\n")
      
      c2 <- fastgreedy.community(g)
      cat("fastgreedy = ", modularity(c2) ,"\n")
      
      c3 <- label.propagation.community(g)
      cat("label.propagation = ", modularity(c3) ,"\n")
      
      #c4 <- leading.eigenvector.community(g)
      #cat("leading.eigenvector = ", modularity(c4) ,"\n")
      
      c5 <- multilevel.community(g)
      cat("louvain method = ", modularity(c5) ,"\n")
      
      #c6 <- optimal.community(g)
      #cat("optimal.community = ", modularity(c6) ,"\n")
      
      #c7 <-spinglass.community(g)
      #cat("spinglass.community = ", modularity(c7) ,"\n")
      
      c8 <-walktrap.community(g)
      cat("walktrap.community = ", modularity(c8) ,"\n")
}


# names(attrData)
# V(g)$student_fac = attrData$student_fac
# V(g)$gender = attrData$gender
# V(g)$major = attrData$major
# V(g)$second_major = attrData$second_major
# V(g)$dorm = attrData$dorm
# V(g)$year = attrData$year
# V(g)$high_school = attrData$high_school
# # 
#  list.vertex.attributes(g) 
#  vertex_attr(g, "gender") 
#  vertex_attr(g, "year") 

