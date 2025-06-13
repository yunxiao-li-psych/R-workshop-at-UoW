data{
  int N;
  array[N] real obs;
}

parameters{
  real mu;
  real sigma;
}

transformed parameters{
  es = abs(mu-20)/sigma;
}

model{
//Prior
mu ~ normal(20, 10);
sigma ~ normal(0, 10)T[0, ];

//Likelihood function
for (i in 1:N){
  obs ~ normal(mu, sigma);
}

}
