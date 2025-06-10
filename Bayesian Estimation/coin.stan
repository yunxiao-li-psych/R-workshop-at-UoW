data{
  int N;
  array[N] int y;
}

parameters {
  real theta;
}

model {
  for (i in 1:N){
    y[i] ~ bernoulli(theta);
  }
}
