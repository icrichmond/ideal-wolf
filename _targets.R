# Source ------------------------------------------------------------------
library(targets)
tar_source('R')


# Options -----------------------------------------------------------------
# Targets
tar_option_set(format = 'qs')



# Targets -----------------------------------------------------------------
c(
  
  tar_target(
    dag,
    make_dag()
  ),
  
  tar_file_read(
    kills_raw,
    'data/killdata/2021-09-17_RMNP_Matched_Sites_sortedClu.csv',
    read.csv(!!.x)
  ),
  
  tar_file_read(
    summ_data,
    'data/2021-09-19-Bloc-DielModel.csv',
    read.csv(!!.x)
  ),
  
  tar_file_read(
    vv_data,
    'data/vander-vennen/VanderVennen_etal_WolfMooseKillRates.csv',
    read.csv(!!.x) |>
      rename(TimeBin = Time.Bin,
             KillRate = Kill.Rate,
             MooseSpeed = Moose.Speed,
             WolfSpeed = Wolf.Speed,
             CrepuscularLight = Crepuscular.Light,
             TotalLight = Total.Light)
  ),
  
  # rate ~ effective_speed * distance/detectability * density
  # effective_speed = sqrt(predator_speed^2 + prey_speed^2)
  
  zar_brms(
    vv_model,
    # VV log-transformed so equation would be additive (? doesn't make sense without logged response) + counted light as detectability
    formula = bf(KillRate ~ effectspeed + CrepuscularLight + TotalLight,
                 effectspeed ~ sqrt(MooseSpeed^2 + WolfSpeed^2),
                 CrepuscularLight + TotalLight ~ 1,
                 nl=TRUE),
    prior = c(
      prior(exponential(1), class = 'sigma'),
      prior(normal(0.5, 2), lb = 0, nlpar = "effectspeed"),
      prior(normal(0.5, 2), lb = 0, nlpar = "CrepuscularLight"),
      prior(normal(0.5, 2), lb = 0, nlpar = "TotalLight")),
    family = gaussian(), # should this be Poisson? it is a kill rate 
    data = vv_data,
    chains = 4,
    iter = 2000,
    cores = 4,
    backend = 'cmdstanr'
  ),
  
  tar_target(
    model_prior_list,
    list(vv_model_brms_sample_prior) %>% 
      setNames(., 'VanderVennen_prior')
  ),
  
  tar_target(
    model_list,
    list(vv_model_brms_sample) %>% 
      setNames(., 'VanderVennen')
  ),
  
  tar_render(
    prior_checks,
    path = 'output/figures/diagnostics/prior_predictive.qmd',
    working_directory = NULL
  ),
  
  tar_render(
    diagnostic_checks,
    path = 'output/figures/diagnostics/model_diagnostics.qmd',
    working_directory = NULL
  )
  
  
)