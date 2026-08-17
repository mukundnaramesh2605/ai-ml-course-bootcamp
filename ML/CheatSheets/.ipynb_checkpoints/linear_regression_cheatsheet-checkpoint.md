# Linear Regression Analysis Cheat Sheet

A copy-paste workflow to evaluate whether a linear regression model is good.

---

## 0. Setup

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.metrics import r2_score, mean_squared_error, mean_absolute_error

df = pd.read_csv("student_scores.csv")

X = df[["hours_studied", "attendance_pct", "previous_score", "sleep_hours"]]
y = df["final_score"]

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)
```

---

## 1. Fit the model

```python
model = LinearRegression().fit(X_train, y_train)

train_pred = model.predict(X_train)
test_pred  = model.predict(X_test)
```

---

## 2. Fit metrics (how close predictions are)

```python
r2   = r2_score(y_test, test_pred)
mse  = mean_squared_error(y_test, test_pred)
rmse = np.sqrt(mse)
mae  = mean_absolute_error(y_test, test_pred)

print(f"R2   : {r2:.3f}")
print(f"MSE  : {mse:.3f}")
print(f"RMSE : {rmse:.3f}   (avg error in target units)")
print(f"MAE  : {mae:.3f}   (avg error, outlier-resistant)")
```

How to read them:
- R2 = fraction of variance explained. 0 means no better than the mean, 1 is perfect. "Good" depends on domain and noise.
- RMSE = typical error in the target's own units. Penalizes big misses.
- MAE = average absolute error. More robust to outliers.
- RMSE much larger than MAE means a few large errors. Close together means uniform errors.

---

## 3. Overfitting check (train vs test)

```python
print("Train R2:", r2_score(y_train, train_pred))
print("Test  R2:", r2_score(y_test,  test_pred))
```

- Close together -> generalizes well.
- Train much higher than test -> overfitting.
- Both low -> underfitting (model too simple).

---

## 4. Cross-validation (is the score stable?)

```python
scores = cross_val_score(model, X, y, cv=5, scoring="r2")
print("CV R2 per fold:", np.round(scores, 3))
print("CV R2 mean :", scores.mean().round(3))
print("CV R2 std  :", scores.std().round(3))
```

- Low std -> reliable, single split was not a fluke.
- High std -> result depends heavily on the split, treat with caution.

---

## 5. Residual analysis (are errors random?)

```python
residuals = y_test - test_pred

plt.figure(figsize=(6, 4))
plt.scatter(test_pred, residuals)
plt.axhline(0, color="red", linestyle="--")
plt.xlabel("Predicted")
plt.ylabel("Residual (actual - predicted)")
plt.title("Residual plot")
plt.tight_layout()
plt.show()
```

What to look for:
- Shapeless cloud around zero -> good, linear assumption holds.
- Curve or pattern -> relationship is not linear, missing a feature or a transform.
- Funnel shape -> error variance not constant (heteroscedasticity).
- Isolated far points -> outliers the model cannot handle.

Optional: histogram of residuals should look roughly bell-shaped and centered on zero.

```python
plt.hist(residuals, bins=15)
plt.title("Residual distribution")
plt.show()
```

---

## 6. Coefficient inspection (which feature matters)

Scale first so coefficients are comparable across different feature ranges.

```python
pipe = Pipeline([
    ("scaler", StandardScaler()),
    ("model", LinearRegression())
]).fit(X_train, y_train)

coefs = pipe.named_steps["model"].coef_
for name, c in zip(X.columns, coefs):
    print(f"{name:16s}: {c:.3f}")
```

With standardized features, a larger absolute coefficient means a bigger effect on the target.

---

## 7. Baseline and model comparison

```python
# Baseline: always predict the mean
baseline_pred = np.full_like(y_test, y_train.mean(), dtype=float)
print("Baseline R2:", r2_score(y_test, baseline_pred))  # ~0 by definition

# Univariate vs multivariate
uni = LinearRegression().fit(X_train[["hours_studied"]], y_train)
print("Univariate R2 :", uni.score(X_test[["hours_studied"]], y_test))
print("Multivariate R2:", model.score(X_test, y_test))
```

If multivariate beats univariate by a wide margin, the extra features earn their place. If barely, one feature was doing most of the work.

---

## Quick decision guide

| Symptom | Likely issue | Action |
|---|---|---|
| Low train and test R2 | Underfitting | Add features, try non-linear model |
| High train, low test R2 | Overfitting | Regularize (Ridge/Lasso), get more data |
| High CV std | Unstable result | More data, more folds, check outliers |
| Pattern in residuals | Non-linearity | Transform features, polynomial terms |
| Funnel residuals | Heteroscedasticity | Transform target (e.g. log) |
| RMSE >> MAE | A few large errors | Investigate outliers |
