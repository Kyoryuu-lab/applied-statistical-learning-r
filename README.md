<h1>applied-statistical-learning-r</h1>
<p>Comprehensive econometric and statistical learning suite in R: OLS diagnostics, logistic classification (GLM), interaction terms, and qualitative dummy modeling</p>

<h2>Project description</h2>
<p>This project implements an end-to-end econometric and statistical machine learning pipeline in R based on classical empirical benchmarks (ISLR curriculum):</p>
<ol>
  <li>
    <dl>
      <dt><b>Module 1 — Ordinary Least Squares (OLS) &amp; Non-linear Scaling (Auto dataset):</b></dt>
      <dd>Models vehicle efficiency (<code>mpg ~ horsepower</code>) and evaluates goodness-of-fit metrics (<i>R²</i>).</dd>
      <dd>Applies non-linear response transformations (<code>sqrt(mpg)</code>, <code>log(mpg)</code>) to stabilize residual variance.</dd>
      <dd>Performs 4-panel regression diagnostics: Residuals vs. Fitted, Normal Q-Q, Scale-Location, and Cook's distance leverage.</dd>
    </dl>
  </li>
  <li>
    <dl>
      <dt><b>Module 2 — Binary Logistic Classification &amp; Generalized Linear Models (Default dataset):</b></dt>
      <dd>Predicts financial credit default probabilities using binomial family GLM (<code>glm(default ~ income + balance, family = "binomial")</code>).</dd>
      <dd>Implements a 70/30 train-test partition to safeguard against over-optimistic in-sample bias.</dd>
      <dd>Evaluates classification error rates across stochastic seeds at a 50% decision boundary threshold.</dd>
    </dl>
  </li>
  <li>
    <dl>
      <dt><b>Module 3 — Outlier Filtering, Interaction Terms &amp; ANOVA (Abalone dataset):</b></dt>
      <dd>Purges extreme measurement artifacts using the Interquartile Range criterion (<code>Q1 - 1.5·IQR</code> to <code>Q3 + 1.5·IQR</code>).</dd>
      <dd>Models physical interaction effects (<code>Diameter * Height</code>) and log-transformed metrics (<code>log(Diameter)</code>).</dd>
      <dd>Formally validates synergy improvements via Analysis of Variance (<code>anova</code>) F-testing.</dd>
    </dl>
  </li>
  <li>
    <dl>
      <dt><b>Module 4 — Qualitative Predictors &amp; Contrast Encoding (Carseats dataset):</b></dt>
      <dd>Encodes multi-class categorical features (<code>ShelveLoc</code>, <code>Urban</code>, <code>US</code>) into factorial dummy levels.</dd>
      <dd>Inspects design contrast matrices and isolates relative brand placement impacts on retail unit sales.</dd>
    </dl>
  </li>
</ol>

<h2>Project files</h2>
<table>
  <tr>
    <th colspan="2">applied-statistical-learning-r</th>
  </tr>
  <tr>
    <td>main.R</td>
    <td>Automated master CLI orchestrator executing all 4 statistical modules with tabular console metrics</td>
  </tr>
  <tr>
    <td>scripts/01_linear_regression_auto.R</td>
    <td>Univariate and multivariate OLS regression, diagnostic residual plots, and variance stabilization</td>
  </tr>
  <tr>
    <td>scripts/02_logistic_classification_default.R</td>
    <td>Binomial GLM logistic modeling, probability scoring, and test-sample accuracy analysis</td>
  </tr>
  <tr>
    <td>scripts/03_interaction_outliers_abalone.R</td>
    <td>IQR outlier sanitation, multiplicative interaction terms, and ANOVA hypothesis tests</td>
  </tr>
  <tr>
    <td>scripts/04_categorical_encoding_carseats.R</td>
    <td>Factor contrasts, qualitative dummy variables, and multiple sales regression</td>
  </tr>
  <tr>
    <td>README.md</td>
    <td>Project documentation and econometric model specifications</td>
  </tr>
  <tr>
    <td>.gitignore</td>
    <td>Exclusion rules for R workspaces (.RData), history (.Rhistory), and RStudio environments</td>
  </tr>
</table>

<h2>Econometric &amp; Statistical Modeling Summary</h2>
<table>
  <tr>
    <th>Module / Dataset</th>
    <th>Model Type</th>
    <th>Key Predictors</th>
    <th>Statistical Criterion</th>
  </tr>
  <tr>
    <td><b>1. Auto</b></td>
    <td>OLS Linear &amp; Non-linear</td>
    <td><code>horsepower</code>, <code>weight</code></td>
    <td>R² optimization &amp; Residual homoscedasticity</td>
  </tr>
  <tr>
    <td><b>2. Default</b></td>
    <td>Logistic Regression (GLM)</td>
    <td><code>balance</code>, <code>income</code></td>
    <td>Misclassification error rate (70/30 Test split)</td>
  </tr>
  <tr>
    <td><b>3. Abalone</b></td>
    <td>Interaction OLS &amp; Log-Linear</td>
    <td><code>Diameter * Height</code>, <code>log(Diameter)</code></td>
    <td>Adjusted R² &amp; ANOVA F-test significance</td>
  </tr>
  <tr>
    <td><b>4. Carseats</b></td>
    <td>Dummy-Encoded Multiple OLS</td>
    <td><code>Price</code>, <code>Advertising</code>, <code>ShelveLoc</code></td>
    <td>Contrasts matrix &amp; p-value significance levels</td>
  </tr>
</table>

<h2>Installation and launch</h2>
<ol>
  <b>
    <li>
      <dl>
        <dt>Clone repository</dt>
        <dd>
          <code>git clone https://github.com/Kyoryuu-lab/applied-statistical-learning-r.git</code>
        </dd>
        <dd>
          <code>cd applied-statistical-learning-r</code>
        </dd>
      </dl>
    </li>
  </b>
  <b>
    <li>
      <dl>
        <dt>Execute unified statistical runner</dt>
        <dd>Runs entirely via the base R distribution:</dd>
        <dd>
          <code>Rscript main.R</code>
        </dd>
      </dl>
    </li>
  </b>
</ol>

<h2>Example of console output (Rscript main.R)</h2>
<samp>
  <p>
    ==============================================================================<br />
    &nbsp;&nbsp;APPLIED STATISTICAL LEARNING &amp; REGRESSION MODELING IN R<br />
    ==============================================================================<br />
    <br />
    ==============================================================================<br />
    &nbsp;&nbsp;MODULE 1: LINEAR REGRESSION &amp; TRANSFORMATIONS (AUTO DATASET)<br />
    ==============================================================================<br />
    [*] OLS Base Model (mpg ~ horsepower):<br />
    &nbsp;&nbsp;&nbsp;&nbsp;Intercept: 39.9359<br />
    &nbsp;&nbsp;&nbsp;&nbsp;Slope:&nbsp;&nbsp;&nbsp;&nbsp; -0.1578<br />
    &nbsp;&nbsp;&nbsp;&nbsp;R-squared: 0.6059<br />
    <br />
    [+] Transformed Model (sqrt(mpg) ~ horsepower):<br />
    &nbsp;&nbsp;&nbsp;&nbsp;R-squared: 0.6437<br />
    <br />
    ==============================================================================<br />
    &nbsp;&nbsp;MODULE 2: LOGISTIC REGRESSION GLM (DEFAULT DATASET)<br />
    ==============================================================================<br />
    [+] Test Set Evaluation (Threshold = 0.5):<br />
    &nbsp;&nbsp;&nbsp;&nbsp;Total Test Observations: 300<br />
    &nbsp;&nbsp;&nbsp;&nbsp;Misclassification Error:&nbsp;&nbsp;2.67 %<br />
    &nbsp;&nbsp;&nbsp;&nbsp;Accuracy:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;97.33 %<br />
    <br />
    ==============================================================================<br />
    &nbsp;&nbsp;MODULE 3: IQR OUTLIERS &amp; INTERACTION MODELING (ABALONE DATASET)<br />
    ==============================================================================<br />
    [*] Outlier Treatment via IQR:<br />
    &nbsp;&nbsp;&nbsp;&nbsp;Original Samples: 500<br />
    &nbsp;&nbsp;&nbsp;&nbsp;Retained Clean:&nbsp;&nbsp; 487<br />
    <br />
    [*] Adjusted R-squared (Base):&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0.5214<br />
    [+] Adjusted R-squared (Interaction): 0.5582<br />
    [*] ANOVA Model Comparison (F-Test): p-value = 3.12e-09 (Statistically Significant)<br />
    <br />
    ==============================================================================<br />
    &nbsp;&nbsp;ALL STATISTICAL SUITES EXECUTED SUCCESSFULLY.<br />
    ==============================================================================<br />
  </p>
