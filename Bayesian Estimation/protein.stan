data{
  int N;
  array[N] real y;
}

parameters{
  real mu;
  real sigma;
}

transformed parameters {
  real es = (mu-20)/sigma;
}

model{
  
  mu ~ normal(20, 20);
  sigma ~ normal(0, 10)T[0,];
  
  for (i in 1:N) {
    y ~ normal(mu, sigma);
  }
}
