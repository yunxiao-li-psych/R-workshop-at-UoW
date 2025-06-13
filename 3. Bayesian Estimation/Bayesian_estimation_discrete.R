library(ggplot2)

likelihood_func <- function(theta, obs){
  ll <- theta^sum(obs) * (1-theta)^(length(obs)-sum(obs))
  return(ll)
}

obs <- c(1, 0, 1, 1, 0, 1)

likelihood_func(0.67, obs)

# Discrete Prior 1 ----------
df_bs <- data.frame(theta = seq(0, 1, by = 0.1), prior = rep(1/11, 11))

fig_prior <- ggplot(df_bs, aes(x=theta, y=prior)) +
  geom_bar(stat = "identity", width = 0.04) +
  scale_x_continuous(breaks = seq(0, 1, by = 0.1)) +
  xlab(expression(theta)) +
  theme_minimal()

# ggsave('images/discrete_coin_prior.png', plot = fig_prior, width = 10, height =10, units = 'cm')

# ...... The Bayes' Theorem Part ..........
}

df_bs$likelihood <- likelihood_func(df_bs$theta, obs)
df_bs$product <- df_bs$likelihood*df_bs$prior
df_bs$posterior <- df_bs$likelihood/(sum(df_bs$likelihood))

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

# Discrete Prior 2 ----------
df_bs2 <- data.frame(theta = seq(0, 1, by = 0.1), prior = seq(1.8, 0.2, by = -0.16)/11)

fig_prior <- ggplot(df_bs2, aes(x=theta, y=prior)) +
  geom_bar(stat = "identity", width = 0.04) +
  scale_x_continuous(breaks = seq(0, 1, by = 0.1)) +
  xlab(expression(theta)) +
  theme_minimal()

# ..... Practice ......
df_bs2$likelihood <- likelihood_func(df_bs2$theta, c(1, 0, 1, 1, 0, 1))
df_bs2$product <- df_bs2$likelihood * df_bs2$prior
df_bs2$posterior <- df_bs2$product / sum(df_bs2$product)

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
