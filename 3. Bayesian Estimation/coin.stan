data{
  int N;
  array[N] int obs;
}

parameters {
  real theta;
}

model {
// Prior
theta ~ beta(2,2);

// Likelihood function
for (i in 1:N){
  obs ~ bernoulli(theta);
}

}
