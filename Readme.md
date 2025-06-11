# Read me

This repository is for the R workshop at the University of Warwick on 13th June 2025. It consists of three topics: the basic operation of R, data visualization and inferential Statistics, and doing Bayesian estimation and inference in R and Stan. To get started, simply click the green “Code” button in the top-right corner and select "Download ZIP" to download everything you need.

## Basic Operation of R
This section introduces the basic functionality of R, preparing you for data visualization, analysis, and more advanced statistical tasks.

To get started, you'll need to install R and RStudio by following the instructions:
1. If you're using your personal computer:
Download and install both R and RStudio. This video provides a step-by-step guide: https://www.youtube.com/watch?v=YrEe2TLr3MI

2. If you're using a departmental computer:
Open the Software Center application on your computer and download RStudio directly from there.

## Bayesian Estimation and Inference

This section is designed as a beginner-friendly introduction to Bayesian estimation and inference. We’ll cover the basics and aim to make everything as clear as possible. The topics include:
- The Bayes Rule
- The Bayesian estimation
- Hypothesis tests via Bayesian estimation

### Preparation

To get started, you’ll need to install `rstan`, `bayesplot` and `HDInterval`. The first package is the key package we’ll use for Bayesian estimation, and the next two packages are for ploting figures. Please use the code below to install the packages
```{R}
# In your R concole.

install.packages("rstan", repos = "https://cloud.r-project.org/", dependencies = TRUE) # install rstan

install.packages(c("bayesplot", "HDInterval")) # install bayesplot and HDInterval
```

You don’t need an in-depth background in statistics to join in, but it will help if you’re familiar with some basic concepts, like the Beta distributions and the idea of a likelihood function. If these sound new to you, don’t worry—just watch the videos we’ve linked to get up to speed.
- [Probability and likelihood](https://youtu.be/pYxNSUDSFH4?si=0mp3Sduo_NodHotr);
- [Beta distribution](https://youtu.be/aVCImOiJklM?si=2gGneKHPS-T_JzV4).

### Further Reading

Because we’re limited on time, we’ll only cover the basics of Bayesian estimation in this workshop. But there’s a lot more you can do with Bayesian methods if you want to explore further. Here are some books and papers to get you started:

- Kruschke, J. K. (2015). _Doing Bayesian data analysis: A tutorial with R, JAGS, and Stan_. Academic Press.  
A great book for beginners—very hands-on, and covers just about every kind of statistical analysis you can do with Bayesian methods.
- Kruschke, J. K. (2012). Bayesian estimation supersedes the t test. Journal of Experimental Psychology: General, 142(2), 573–603. https://doi.org/10.1037/a0029146  
This paper is a good introduction to how Bayesian estimation can replace traditional _t_-tests for hypothesis testing.
- Gelman, A., Vehtari, A., Simpson, D., Margossian, C. C., Carpenter, B., Yao, Y., Kennedy, L., Gabry, J., Bürkner, P.-C., & Modrák, M. (2020). Bayesian Workflow. _arXiv:2011.01808 [Stat]_. http://arxiv.org/abs/2011.01808  
If you’re keen to write your own Bayesian models, this paper is a must-read. It lays out a clear roadmap for doing Bayesian modelling and is packed with practical tips.