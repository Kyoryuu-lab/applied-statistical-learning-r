# ==============================================================================
# Project:     Applied Statistical Learning & Regression Modeling in R
# File:        main.R
# Author:      Yevhen Biezhyn
# Description: Automated master orchestrator executing all four statistical
#              paradigms: OLS Diagnostics, Logistic GLM, Interaction Modeling,
#              and Qualitative Categorical Encoding.
# ==============================================================================

print_banner <- function(title) {
  cat("\n", paste(rep("=", 78), collapse = ""), "\n", sep = "")
  cat("  ", toupper(title), "\n", sep = "")
  cat(paste(rep("=", 78), collapse = ""), "\n\n", sep = "")
}

# ------------------------------------------------------------------------------
# 1. Линейная регрессия и нелинейные преобразования (Auto)
# ------------------------------------------------------------------------------
run_auto_module <- function() {
  print_banner("Module 1: Linear Regression & Transformations (Auto Dataset)")

  if (!file.exists("data/Auto.csv")) {
    cat("[!] Auto.csv not found in data/. Generating synthetic benchmark data...\n")
    df <- data.frame(
      mpg = c(18, 15, 18, 16, 17, 15, 14, 14, 14, 15, 24, 22, 21),
      horsepower = c(130, 165, 150, 150, 140, 198, 220, 215, 225, 190, 95, 95, 110),
      weight = c(3504, 3693, 3436, 3433, 3449, 4341, 4354, 4312, 4425, 3850, 2372, 2833, 2774),
      year = c(70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 71, 72)
    )
  } else {
    df <- read.csv("data/Auto.csv")
    df$horsepower <- suppressWarnings(as.numeric(as.character(df$horsepower)))
    df <- na.omit(df)
  }

  # Базовая линейная регрессия
  model_base <- lm(mpg ~ horsepower, data = df)
  cat("[*] OLS Base Model (mpg ~ horsepower):\n")
  cat("    Intercept:", round(coef(model_base)[1], 4), "\n")
  cat("    Slope:    ", round(coef(model_base)[2], 4), "\n")
  cat("    R-squared:", round(summary(model_base)$r.squared, 4), "\n\n")

  # Нелинейное преобразование корня
  df$sqrt_mpg <- sqrt(df$mpg)
  model_trans <- lm(sqrt_mpg ~ horsepower, data = df)
  cat("[+] Transformed Model (sqrt(mpg) ~ horsepower):\n")
  cat("    R-squared:", round(summary(model_trans)$r.squared, 4), "\n")
}

# ------------------------------------------------------------------------------
# 2. Логистическая регрессия и классификация кредитного дефолта (Default)
# ------------------------------------------------------------------------------
run_default_module <- function() {
  print_banner("Module 2: Logistic Regression GLM (Default Dataset)")

  set.seed(123)
  n <- 1000
  df <- data.frame(
    balance = rnorm(n, mean = 1000, sd = 400),
    income = rnorm(n, mean = 35000, sd = 10000)
  )
  df$prob <- 1 / (1 + exp(-( -10 + 0.005 * df$balance + 0.00002 * df$income )))
  df$default <- ifelse(runif(n) < df$prob, 1, 0)

  # 70/30 Train-Test Split
  train_idx <- sample(1:n, size = 0.7 * n)
  train_data <- df[train_idx, ]
  test_data  <- df[-train_idx, ]

  # Обучение биномиальной логистической модели
  logit_model <- glm(default ~ income + balance, data = train_data, family = "binomial")
  pred_prob <- predict(logit_model, newdata = test_data, type = "response")
  pred_class <- ifelse(pred_prob > 0.5, 1, 0)
  error_rate <- mean(pred_class != test_data$default)

  cat("[*] Logistic GLM Parameters:\n")
  print(coef(logit_model))
  cat("\n[+] Test Set Evaluation (Threshold = 0.5):\n")
  cat("    Total Test Observations:", nrow(test_data), "\n")
  cat("    Misclassification Error: ", round(error_rate * 100, 2), "%\n")
  cat("    Accuracy:                ", round((1 - error_rate) * 100, 2), "%\n")
}

# ------------------------------------------------------------------------------
# 3. Фильтрация выбросов (IQR), эффект взаимодействия и ANOVA (Abalone)
# ------------------------------------------------------------------------------
run_abalone_module <- function() {
  print_banner("Module 3: IQR Outliers & Interaction Modeling (Abalone Dataset)")

  set.seed(42)
  n <- 500
  df <- data.frame(
    Diameter = runif(n, 0.2, 0.6),
    Height = runif(n, 0.05, 0.25),
    Whole.weight = runif(n, 0.2, 2.0)
  )
  df$Rings <- round(5 + 10 * df$Diameter + 8 * df$Height + 4 * (df$Diameter * df$Height) + rnorm(n, 0, 1.5))

  # IQR фильтрация выбросов
  iqr_filter <- function(x) {
    q <- quantile(x, probs = c(0.25, 0.75))
    iqr_val <- IQR(x)
    return(x >= (q[1] - 1.5 * iqr_val) & x <= (q[2] + 1.5 * iqr_val))
  }

  clean_data <- df[iqr_filter(df$Diameter) & iqr_filter(df$Height) & iqr_filter(df$Whole.weight), ]
  cat("[*] Outlier Treatment via IQR:\n")
  cat("    Original Samples:", nrow(df), "\n")
  cat("    Retained Clean:  ", nrow(clean_data), "\n\n")

  # Базовая модель vs Модель с взаимодействием (Interaction)
  m_base <- lm(Rings ~ Diameter + Height + Whole.weight, data = clean_data)
  m_inter <- lm(Rings ~ Diameter * Height + Whole.weight, data = clean_data)

  cat("[*] Adjusted R-squared (Base):       ", round(summary(m_base)$adj.r.squared, 4), "\n")
  cat("[+] Adjusted R-squared (Interaction):", round(summary(m_inter)$adj.r.squared, 4), "\n\n")

  cat("[*] ANOVA Model Comparison (F-Test):\n")
  print(anova(m_base, m_inter))
}

# ------------------------------------------------------------------------------
# 4. Качественные предикторы и дамми-кодирование (Carseats)
# ------------------------------------------------------------------------------
run_carseats_module <- function() {
  print_banner("Module 4: Qualitative Predictors & Contrasts (Carseats Dataset)")

  set.seed(99)
  n <- 400
  df <- data.frame(
    Price = runif(n, 50, 150),
    Advertising = runif(n, 0, 25),
    ShelveLoc = sample(c("Bad", "Medium", "Good"), n, replace = TRUE),
    Urban = sample(c("Yes", "No"), n, replace = TRUE),
    US = sample(c("Yes", "No"), n, replace = TRUE)
  )
  df$Sales <- 5 + 0.05 * df$Advertising - 0.03 * df$Price +
              ifelse(df$ShelveLoc == "Good", 4, ifelse(df$ShelveLoc == "Medium", 2, 0)) + rnorm(n)

  # Преобразование в факторы и просмотр контрастов
  df$ShelveLoc <- as.factor(df$ShelveLoc)
  df$Urban     <- as.factor(df$Urban)
  df$US        <- as.factor(df$US)

  cat("[*] Contrast Matrix for ShelveLoc:\n")
  print(contrasts(df$ShelveLoc))
  cat("\n")

  # Обучение модели с фиктивными переменными (Dummy Variables)
  sales_model <- lm(Sales ~ Price + Advertising + ShelveLoc + Urban + US, data = df)
  cat("[+] Multiple Regression Output with Qualitative Predictors:\n")
  print(summary(sales_model)$coefficients)
}

# ------------------------------------------------------------------------------
# Entry Point
# ------------------------------------------------------------------------------
main <- function() {
  cat("\n==============================================================================\n")
  cat("  APPLIED STATISTICAL LEARNING & REGRESSION MODELING IN R\n")
  cat("==============================================================================\n")

  run_auto_module()
  run_default_module()
  run_abalone_module()
  run_carseats_module()

  cat("\n==============================================================================\n")
  cat("  ALL STATISTICAL SUITES EXECUTED SUCCESSFULLY.\n")
  cat("==============================================================================\n\n")
}

main()
