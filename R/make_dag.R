make_dag <- function(){
  
  dagified <- dagify(
    Kills ~ Vulnerability + Speed + Light,
    Speed ~ Light + Vulnerability,
    labels = c(
      "Kills" = "Kills",
      "Speed" = "Speed",
      "Light" = "Light",
      "Vulnerability" = "Vulnerability"
    ),
    coords = list(y = c(Kills = 1, Vulnerability = 0, Speed = -1, Light = 0),
                  x = c(Kills = 0, Vulnerability = 0.5, Speed = 0, Light = -0.5)))
  
  i <- ggdag(dagified, node_size = 20, text = F) +
    theme_dag() + 
    geom_dag_label(aes(label = label))
  
  
  ggsave('output/figures/DAG.png', plot = i, width = 15, height = 12, units = "in")
  
  return(dagified)
  
  
}