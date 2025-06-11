library(rstan)
library(bayesplot)
library(HDInterval)
library(ggplot2)
library(tidyr)

set.seed(2025)

data <- read.csv("energy_bar.csv")
fig_hist <- ggplot(data, aes(x=protein)) +
  geom_histogram(bins = 13) +
  theme_minimal()
fig_hist


# Frequentist t-test --------
t_value <- (mean(data$protein) - 20) / (sd(data$protein)/sqrt(length(data$protein)))

# Plot the student t distribution
fig_t <- data.frame(x = seq(-3, 3, by =0.01), y = dt(seq(-3, 3, by =0.01), df = 49)) %>%
  ggplot(aes(x = x, y = y)) +
  geom_line() +
  annotate("point", x = t_value, y = 0, color = 'red') +
  annotate("point", x = -1 * t_value, y = 0, color = 'red') +
  geom_area(data = data.frame(x = seq(-3, -1 * t_value, by =0.01), y = dt(seq(-3, -1 * t_value, by =0.01), df = 49)),
            alpha = 0.4) +
  geom_area(data = data.frame(x = seq(t_value, 3, by =0.01), y = dt(seq(t_value, 3, by =0.01), df = 49)),
            alpha = 0.4) +
  theme_minimal()

p_value <- pt(-1 * t_value, df = 49) + pt(t_value, df = 49, lower.tail = FALSE)

t.test(data$protein, mu = 20)

# Decompose the p-value --------

population <- rnorm(100000, mean = 20, sd = sd(data$protein)) # if the null hypothesis is true

# repeatedly draw 50 samples from the population
t_value <- vector(mode = 'numeric', length = 1000)
for (i in 1:1000) {
  s <- sample(population, size = 50)
  t <- (mean(s) - 20) / (sd(s)/sqrt(length(s)))
  t_value[i] <- t
}

fig_sample <- data.frame(t = t_value) %>%
  ggplot(mapping = aes(x = t)) +
  geom_histogram(aes(y = after_stat(density)), alpha = 0.7) +
  geom_line(data = data.frame(x = seq(-3, 3, by =0.01), y = dt(seq(-3, 3, by =0.01), df = 49)),
            mapping = aes(x = x, y = y))
  

# Bayesian estimation --------

protein_model <- stan_model('protein.stan')
data_list <- list(N = length(data$protein),
                  y = data$protein)

fit <- sampling(protein_model, data = data_list,
                chains = 4, iter = 4000, warmup = 2000, cores = 4)

print(fit, pars = c('mu', 'sigma'))

samples <- as.array(fit)

mcmc_trace(samples, pars = c('mu', 'sigma'))
mcmc_hist(samples, pars = c('mu', 'sigma'))

# Calculate HDI
posterior_mu <- rstan::extract(fit, pars = 'mu')$mu
hdi_mu <- hdi(posterior_mu)

fig_post_mu <- ggplot(data.frame(mu = posterior_mu), aes(x = mu, y = after_stat(density))) +
  geom_histogram(fill = 'skyblue', color = 'skyblue') +
  annotate('segment', x = hdi_mu[1], xend = hdi_mu[2], y = 0, yend = 0,colour = "black", linewidth = 2)+
  annotate('text', x = hdi_mu[1], y = 1, label = round(hdi_mu[1], 1)) +
  annotate('text', x = hdi_mu[2], y = 1, label = round(hdi_mu[2], 1)) +
  theme_minimal()


# Effect size
posterior_es <- rstan::extract(fit, pars = 'es')$es
hdi_es <- hdi(posterior_es)

fig_post_es <- ggplot(data.frame(es = posterior_es), aes(x = es, y = after_stat(density))) +
  geom_histogram(fill = 'skyblue', color = 'skyblue') +
  annotate('segment', x = hdi_es[1], xend = hdi_es[2], y = 0, yend = 0,colour = "black", linewidth = 2)+
  annotate('segment', x = 0, xend = 0.2, y = 0, yend = 0, colour = "red", linewidth = 2, alpha = 0.5)+
  annotate('text', x = hdi_es[1], y = 1.5, label = round(hdi_es[1], 2)) +
  annotate('text', x = hdi_es[2], y = 1.5, label = round(hdi_es[2], 2)) +
  annotate('text', x = -0.01, y = 0.5, label = 0, color = 'red') +
  annotate('text', x = 0.21, y = 0.5, label = 0.2, color = 'red') +
  labs(x = 'Effect size') +
  theme_minimal()

