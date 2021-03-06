data {
  int<lower = 0> N;  // размер выборки
  vector[N] X; // вектор наблюдений
}

parameters {
  real<lower = 0, upper = 200> mu; // оцениваемый параметр: среднее нормального распределения
  real<lower = 0> sigma; // оцениваемый параметр: стандартное отклонение нормального распределения
}

model {
  target += uniform_lpdf(mu | 0,200); // априорное распределение среднего
  target += cauchy_lpdf(sigma | 0,15); // априорное распределение стандартного отклонения
  target += normal_lpdf(X | mu, sigma); // функция правдоподобия
}