library(rstan)
library(bayesplot)
library(HDInterval)
library(ggplot2)
library(tidyr)

set.seed(2025)
data <- data.frame(protein = rnorm(50, 20, 1))
write.csv(data, "energy_bar.csv", row.names = FALSE)

data <- read.csv("energy_bar.csv")
fig_hist <- ggplot(data, aes(x=protein)) +
  geom_histogram(bins = 13) +
  theme_minimal()
fig_hist

ggsave("images/protein.png", plot = fig_hist, width = 10, height = 10, units = 'cm')

# Frequentist t-test --------
t_value <- (mean(data$protein) - 20) / (sd(data$protein)/sqrt(length(data$protein)))

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

ggsave("images/ttest.svg", plot = fig_t, width=10, height=10, units = 'cm')

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
  
  
fig_sample


# Bayesian estimation --------

options(mc.cores=4)
protein_model <- stan_model('protein.stan')
data_list <- list(N = length(data$protein),
                  y = data$protein)

fit <- sampling(protein_model, data = data_list,
                chains = 4, iter = 4000, warmup = 2000)

print(fit, pars = c('mu', 'sigma'))

draw <- as.array(fit)

fig_trace <- mcmc_trace(draw, pars = c('mu', 'sigma'))
# ggsave("images/protein_trace.png", plot = fig_trace, width = 20, height = 10, units = 'cm')

fig_trace_es <- mcmc_trace(draw, pars = c('es')) +
  labs(title = 'Effect size', y = NULL) +
  theme(plot.title = element_text(hjust = 0.5))
ggsave("images/protein_trace_es.png", plot = fig_trace_es, width = 10, height = 10, units = 'cm')

fig_post <- mcmc_hist(draw, pars = c('mu', 'sigma'))
# ggsave("images/protein_post.png", plot = fig_post, width = 20, height = 10, units = 'cm')

# Calculate HDI
posterior_mu <- rstan::extract(fit, pars = 'mu')$mu
hdi_mu <- hdi(posterior_mu)

fig_post_mu <- ggplot(data.frame(mu = posterior_mu), aes(x = mu, y = after_stat(density))) +
  geom_histogram(fill = 'skyblue', color = 'skyblue') +
  annotate('segment', x = hdi_mu[1], xend = hdi_mu[2], y = 0, yend = 0,colour = "black", linewidth = 2)+
  annotate('text', x = hdi_mu[1], y = 1, label = round(hdi_mu[1], 1)) +
  annotate('text', x = hdi_mu[2], y = 1, label = round(hdi_mu[2], 1)) +
  theme_minimal()

# ggsave("images/protein_post_mu.svg", plot = fig_post_mu, width = 10, height = 10, units = 'cm')

# Effect size
posterior_es <- rstan::extract(fit, pars = 'es')$es
hdi_es <- hdi(posterior_es)

fig_post_es <- ggplot(data.frame(es = posterior_es), aes(x = es, y = after_stat(density))) +
  geom_histogram(fill = 'skyblue', color = 'skyblue') +
  annotate('segment', x = hdi_es[1], xend = hdi_es[2], y = 0, yend = 0,colour = "black", linewidth = 2)+
  annotate('segment', x = -0.2, xend = 0.2, y = 0, yend = 0, colour = "red", linewidth = 2, alpha = 0.5)+
  annotate('text', x = hdi_es[1], y = 1, label = round(hdi_es[1], 2)) +
  annotate('text', x = hdi_es[2], y = 1, label = round(hdi_es[2], 2)) +
  annotate('text', x = -0.22, y = 0.5, label = -0.2, color = 'red') +
  annotate('text', x = 0.22, y = 0.5, label = 0.2, color = 'red') +
  labs(x = 'Effect size') +
  theme_minimal()
fig_post_es
ggsave("images/protein_post_es.svg", plot = fig_post_es, width = 10, height = 10, units = 'cm')
