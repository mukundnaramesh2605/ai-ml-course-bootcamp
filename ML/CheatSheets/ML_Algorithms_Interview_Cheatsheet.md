# ML Algorithms - Interview Cheat Sheet

Quick, interview-ready answers. Each entry: what it is, how it works, when to use, key trade-offs, and the question interviewers love to ask.

---

## SUPERVISED LEARNING

### 1. Linear Regression
**What:** Predicts a continuous value as a weighted sum of features.
**How:** Fits a line/hyperplane by minimizing mean squared error (usually via Ordinary Least Squares or gradient descent).
**Assumptions:** Linear relationship, independent errors, constant variance (homoscedasticity), normally distributed residuals, low multicollinearity.
**Use when:** Target is continuous and relationships are roughly linear.
**Pros:** Simple, fast, interpretable coefficients.
**Cons:** Poor with non-linear data, sensitive to outliers and multicollinearity.
**Gotcha Q:** "Why MSE and not MAE?" MSE is differentiable everywhere and penalizes large errors more; MAE is robust to outliers but harder to optimize.

### 2. Logistic Regression
**What:** Classification model that predicts probability of a class.
**How:** Applies the sigmoid function to a linear combination of features, trained by minimizing log loss (cross-entropy).
**Use when:** Binary or multiclass (via softmax/one-vs-rest) classification, need probabilities and interpretability.
**Pros:** Interpretable, outputs calibrated probabilities, fast.
**Cons:** Assumes linear decision boundary in feature space.
**Gotcha Q:** "Is it a regression or classification algorithm?" It's classification. The name comes from the log-odds being modeled linearly.

### 3. Decision Tree
**What:** Tree of if/else splits on features leading to a prediction.
**How:** Recursively splits data to maximize purity, using Gini impurity or entropy (information gain) for classification, variance reduction for regression.
**Use when:** Need interpretability, handle mixed feature types, non-linear relationships.
**Pros:** Interpretable, no scaling needed, handles non-linearity.
**Cons:** Overfits easily, unstable (small data changes flip the tree).
**Gotcha Q:** "Gini vs entropy?" Both measure impurity and give similar trees. Gini is faster (no log); entropy is slightly more balanced.

### 4. Random Forest
**What:** Ensemble of decision trees trained on random subsets of data and features.
**How:** Bagging (bootstrap sampling) plus random feature selection at each split; predictions averaged (regression) or majority-voted (classification).
**Use when:** Strong general-purpose baseline for tabular data.
**Pros:** Reduces overfitting vs single tree, robust, gives feature importance.
**Cons:** Less interpretable, larger memory, slower inference.
**Gotcha Q:** "How does it reduce variance?" Averaging many decorrelated trees cancels individual errors. Random feature selection decorrelates the trees.

### 5. Gradient Boosting (XGBoost / LightGBM / CatBoost)
**What:** Ensemble that builds trees sequentially, each correcting the previous one's errors.
**How:** Each new tree fits the residuals (negative gradient of the loss) of the current ensemble.
**Use when:** Tabular data where you want top accuracy; wins most Kaggle competitions.
**Pros:** State-of-the-art on structured data, handles complex patterns.
**Cons:** Prone to overfitting without tuning, slower to train, more hyperparameters.
**Gotcha Q:** "Bagging vs boosting?" Bagging trains trees in parallel to reduce variance; boosting trains sequentially to reduce bias.

### 6. Support Vector Machine (SVM)
**What:** Finds the hyperplane that maximally separates classes.
**How:** Maximizes the margin between classes; the kernel trick maps data to higher dimensions for non-linear boundaries.
**Use when:** Small-to-medium datasets, high-dimensional spaces (e.g. text).
**Pros:** Effective in high dimensions, works with clear margins.
**Cons:** Slow on large datasets, sensitive to kernel/parameter choice, no direct probabilities.
**Gotcha Q:** "What's the kernel trick?" It computes dot products in a high-dimensional space without explicitly transforming data, enabling non-linear separation cheaply.

### 7. K-Nearest Neighbors (KNN)
**What:** Classifies a point by majority vote of its K closest neighbors.
**How:** Stores all data; at prediction time computes distances (e.g. Euclidean) and votes.
**Use when:** Small datasets, low dimensions, simple baseline.
**Pros:** No training phase, simple, non-parametric.
**Cons:** Slow inference, memory-heavy, suffers from curse of dimensionality, needs scaling.
**Gotcha Q:** "How to pick K?" Cross-validation. Small K = noisy/overfit; large K = smoother/underfit. Use odd K for binary to avoid ties.

### 8. Naive Bayes
**What:** Probabilistic classifier applying Bayes' theorem with a strong independence assumption.
**How:** Assumes features are conditionally independent given the class; multiplies per-feature likelihoods.
**Use when:** Text classification, spam filtering, high-dimensional sparse data.
**Pros:** Very fast, works well with little data, great for text.
**Cons:** The independence assumption is usually false (but still works surprisingly well).
**Gotcha Q:** "Why 'naive'?" Because it naively assumes all features are independent given the class.

---

## UNSUPERVISED LEARNING

### 9. K-Means Clustering
**What:** Partitions data into K clusters by minimizing within-cluster variance.
**How:** Iteratively assigns points to the nearest centroid, then recomputes centroids until convergence.
**Use when:** Customer segmentation, exploratory grouping, roughly spherical clusters.
**Pros:** Fast, scalable, simple.
**Cons:** Must pick K upfront, sensitive to initialization and outliers, assumes spherical equal-size clusters.
**Gotcha Q:** "How to choose K?" Elbow method (inertia vs K) or silhouette score. K-means++ improves initialization.

### 10. Hierarchical Clustering
**What:** Builds a tree (dendrogram) of nested clusters.
**How:** Agglomerative (bottom-up merging) or divisive (top-down splitting) based on linkage distance.
**Use when:** Want cluster hierarchy, don't know K in advance, smaller datasets.
**Pros:** No need to pre-specify K, gives interpretable dendrogram.
**Cons:** O(n^2) or worse, doesn't scale, sensitive to linkage choice.
**Gotcha Q:** "Linkage types?" Single (min distance), complete (max), average, and Ward (minimizes variance).

### 11. DBSCAN
**What:** Density-based clustering that finds arbitrarily shaped clusters and flags outliers.
**How:** Groups points with enough neighbors within radius epsilon; points in sparse regions become noise.
**Use when:** Non-spherical clusters, unknown cluster count, need outlier detection.
**Pros:** Finds arbitrary shapes, detects noise, no need to set K.
**Cons:** Struggles with varying densities, sensitive to epsilon and min_samples.
**Gotcha Q:** "K-means vs DBSCAN?" K-means needs K and assumes spherical clusters; DBSCAN infers count and handles arbitrary shapes plus noise.

### 12. PCA (Principal Component Analysis)
**What:** Dimensionality reduction that projects data onto directions of maximum variance.
**How:** Computes eigenvectors of the covariance matrix (or via SVD); keeps top components.
**Use when:** Reduce dimensions, remove correlation, visualize, speed up training.
**Pros:** Reduces overfitting and compute, removes multicollinearity.
**Cons:** Components lose interpretability, only captures linear structure, needs scaling.
**Gotcha Q:** "Is PCA supervised?" No, it ignores labels. Use LDA if you want a supervised, class-aware projection.

---

## KEY CONCEPTS (often asked alongside)

### Bias-Variance Tradeoff
High bias = underfitting (too simple). High variance = overfitting (too complex, sensitive to training data). Goal is the sweet spot minimizing total error.

### Overfitting - how to prevent
Regularization (L1/L2), cross-validation, more data, simpler models, dropout (NNs), early stopping, pruning (trees), ensembling.

### L1 vs L2 Regularization
L1 (Lasso) adds absolute weights, drives some to zero (feature selection). L2 (Ridge) adds squared weights, shrinks smoothly, keeps all features.

### Precision vs Recall
Precision = of predicted positives, how many correct (TP / (TP+FP)). Recall = of actual positives, how many caught (TP / (TP+FN)). F1 = harmonic mean. Use precision when false positives are costly, recall when false negatives are costly.

### Bagging vs Boosting
Bagging: parallel, independent models, reduces variance (Random Forest). Boosting: sequential, each fixes prior errors, reduces bias (XGBoost).

### Generative vs Discriminative
Generative models the joint P(X,Y) (Naive Bayes). Discriminative models P(Y given X) directly (Logistic Regression, SVM).

### Curse of Dimensionality
As dimensions grow, data becomes sparse, distances lose meaning, and models need exponentially more data. Fix with dimensionality reduction or feature selection.

### Cross-Validation
Split data into K folds, train on K-1, validate on the rest, rotate. Gives a robust performance estimate and reduces dependence on a single split.
