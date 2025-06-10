library(ggplot2)

likelihood_func <- function(theta, obs){
  if (!all(obs %in% c(0, 1))){
    stop("`obs` should only involve 0 and 1.")
  }
  
  n <- length(obs)
  return(theta**sum(obs) * (1-theta)**(n-sum(obs)))
}

obs <- c(1, 0, 1, 1, 0, 1)
likelihood_func(0.5, obs)

# Discrete Prior 1 ----------
df_bs <- data.frame(theta = seq(0, 1, by = 0.1), prior = rep(1/11, 11))

fig_prior <- ggplot(df_bs, aes(x=theta, y=prior)) +
  geom_bar(stat = "identity", width = 0.04) +
  scale_x_continuous(breaks = seq(0, 1, by = 0.1)) +
  xlab(expression(theta)) +
  theme_minimal()

# ggsave('images/discrete_coin_prior.png', plot = fig_prior, width = 10, height =10, units = 'cm')

# ...... The Bayes' Theorem Part ..........
df_bs$likelihood <- 

fig_likelihood <- ggplot(df_bs, aes(x=theta, y=likelihood)) +
  geom_bar(stat = "identity", width = 0.04) +
  scale_x_continuous(breaks =seq(0, 1, by = 0.1)) +
  xlab(expression(theta)) +
  theme_minimal()

fig_posteror <- ggplot(df_bs, aes(x=theta, y=posterior)) +
  geom_bar(stat = "identity", width = 0.04) +
  scale_x_continuous(breaks =seq(0, 1, by = 0.1)) +
  xlab(expression(theta)) +
  theme_minimal()

# ggsave('images/discrete_coin_posterior.png', plot = fig_posteror, width = 10, height =10, units = 'cm')

# Discrete Prior 2 ----------
df_bs2 <- data.frame(theta = seq(0, 1, by = 0.1), prior = seq(1.8, 0.2, by = -0.16)/11)

fig_prior <- ggplot(df_bs2, aes(x=theta, y=prior)) +
  geom_bar(stat = "identity", width = 0.04) +
  scale_x_continuous(breaks = seq(0, 1, by = 0.1)) +
  xlab(expression(theta)) +
  theme_minimal()

# ggsave('images/discrete_coin_prior2.png', plot = fig_prior, width = 10, height =10, units = 'cm')

# ..... Practice ......
df_bs2$likelihood <-
df_bs2$product <-
df_bs2$posterior <-

fig_likelihood <- ggplot(df_bs2, aes(x=theta, y=likelihood)) +
  geom_bar(stat = "identity", width = 0.04) +
  scale_x_continuous(breaks =seq(0, 1, by = 0.1)) +
  xlab(expression(theta)) +
  theme_minimal()

fig_posteror <- ggplot(df_bs2, aes(x=theta, y=posterior)) +
  geom_bar(stat = "identity", width = 0.04) +
  scale_x_continuous(breaks =seq(0, 1, by = 0.1)) +
  xlab(expression(theta)) +
  theme_minimal()

# ggsave('images/discrete_coin_posterior2.png', plot = fig_posteror, width = 10, height =10, units = 'cm')
