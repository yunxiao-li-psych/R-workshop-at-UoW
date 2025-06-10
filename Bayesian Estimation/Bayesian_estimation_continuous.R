library(rstan)
library(bayesplot)
library(ggplot2)
library(dplyr)

set.seed(2025)

# Plot the prior distribution ------------
fig_beta <- data.frame(theta = seq(0, 1, by=0.01), prior = dbeta(seq(0, 1, by=0.01), 2, 2)) %>%
  ggplot(aes(x = theta, y = prior)) +
  geom_line() +
  geom_area(alpha = 0.5) +
  xlab(expression(theta)) +
  theme_minimal()
fig_beta



# Hello world for Stan ---------
options(mc.cores=4)
hello_world <- stan_model('hello_world.stan') # compile the .stan file
sampling(hello_world, chain = 1, iter = 2, algorithm = "Fixed_param")

# Bayesian estimation using Stan -----------
coin <- stan_model(stan_file = 'coin.stan')

obs <- c(1, 0, 1, 1, 0, 1)

data_list <- list(y = obs,
                  N = length(obs))

fit <- sampling(coin,
                data=data_list,
                chains = 4,
                parallel_chains = 4,
                iter = 2000,
                warmup = 1000)

print(fit) # learn more about the lp__: https://www.jax.org/news-and-insights/jax-blog/2015/october/lp-in-stan-output

samples <- as.array(fit)

# # Take the first 6 samples
# sub_samples <- samples[1:6, 1, 1]
# 
# fig_trace_step <- data.frame(theta = sub_samples, id = 1:6) %>%
#   ggplot(aes(x = id, y = theta)) +
#   geom_segment(aes(x = id[id], y = theta[id], xend = id[id+1], yend = theta[id+1]),
#                arrow = arrow(length = unit(0.25, "cm")), color = "skyblue", linewidth = 0.5)+
#   geom_point(shape = 16, size = 2) +
#   labs(x = 'Iteration', y = expression(theta)) +
#   scale_x_continuous(breaks = 1:6) +
#   theme_minimal()


fig_trace <- mcmc_trace(samples, pars = 'theta') +
  ylab(expression(theta)) +
  scale_y_continuous(breaks =seq(0, 1, by = 0.1))

fig_hist <- mcmc_hist(samples, pars = 'theta') +
  xlab(expression(theta)) +
  coord_flip()

fig_chain <- plot_grid(fig_trace, fig_hist, ncol = 2)

# ..... Practice ......

obs_new <- sample(c(0, 1), size = 50, replace = TRUE, prob = c(0.2, 0.8))

# complete the .stan file
coin <- cmdstan_model(stan_file = 'coin.stan')

data_list <-

fit <- 

