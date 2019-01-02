data {
	int<lower=1> nY; // количество наблюдений (всего)
	int<lower=1> nS; // количество испытуемых
	int<lower=1,upper=nS> Subj[nY]; // вектор с номерами испытуемых для каждого из наблюдений
	vector[nY] size_diff; // целевой предиктор, разница между стимулами
	vector[nY] num_of_trials; // количество установочных проб, не понадобится в этом анализе
  int<lower = 0, upper = 1> Y[nY]; // результат: какой тип иллюзии наблюдался. 1 - ассимилятивная, 0 - контрастная
}

parameters {
	real intercept; // среднее смещение по всем испытуемым 
  real beta_mu; // средний размер эффекта по популяции
  real<lower = 0> beta_sd; // вариативность размера эффекта среди испытуемых
  vector[nS] beta; // вектор индивидуальных размеров эффекта 
}

model {
	// априорные распределения
	intercept ~ normal(0,10); 
	beta_mu ~ uniform(-4,0); // альтернативная гипотеза!
  beta_sd ~ cauchy(0,3);

	// "откуда" (из какого распределения по популяции) генерировались индивидуальные размеры эффекта
  beta ~ normal(beta_mu, beta_sd);

	// генерация наблюдений с учетом общего смещения и индивидуальных эффектов (логистическая регрессия)
	for(i in 1:nY){
    Y[i] ~ bernoulli_logit(intercept + beta[Subj[i]]*size_diff[i]);
	}
}