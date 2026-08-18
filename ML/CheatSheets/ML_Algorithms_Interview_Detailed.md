# ML Algorithms - Detailed Interview Answers

Each answer is written the way you'd actually say it in an interview: a clear opening definition, the mechanics, when to reach for it, trade-offs, and follow-up traps with strong responses. Read the opening line aloud, then expand as the interviewer probes.

---

## SUPERVISED LEARNING

---

### 1. Linear Regression

**Interview answer:**
"Linear regression predicts a continuous target as a weighted sum of the input features plus a bias term. So the model is y = w0 + w1x1 + w2x2 and so on. Training means finding the weights that minimize the mean squared error between predictions and actual values. You can solve it in closed form with the Normal Equation, or iteratively with gradient descent when the dataset is large."

**How it works, deeper:**
The loss is the average of squared residuals. Because that loss is convex, there's a single global minimum. The Normal Equation gives the exact solution but involves inverting a matrix, which is expensive and unstable when features are many or correlated, so at scale you use gradient descent instead.

**Assumptions (interviewers love these):**
Linearity between features and target, independence of errors, homoscedasticity (constant error variance), normally distributed residuals, and little multicollinearity among features.

**When to use:** Continuous target, roughly linear relationships, and you want interpretable coefficients you can explain to stakeholders.

**Trade-offs:** Simple, fast, interpretable, but underfits non-linear data and is sensitive to outliers and correlated features.

**Follow-ups:**
- "Why squared error instead of absolute error?" Squared error is differentiable everywhere, which makes optimization clean, and it penalizes large errors more heavily. Absolute error (MAE) is more robust to outliers but has a non-smooth gradient at zero.
- "How do you handle multicollinearity?" Drop or combine correlated features, use PCA, or apply Ridge regularization which stabilizes the coefficient estimates.
- "What if the relationship is non-linear?" Add polynomial or interaction terms, or switch to a tree-based or kernel model.

---

### 2. Logistic Regression

**Interview answer:**
"Logistic regression is a classification algorithm, despite the name. It models the probability that an input belongs to a class by passing a linear combination of features through the sigmoid function, which squashes any real number into the zero-to-one range. We train it by minimizing log loss, also called binary cross-entropy."

**How it works, deeper:**
The linear part models the log-odds of the positive class. The sigmoid converts log-odds into a probability. We then threshold, usually at 0.5, to make a decision. There's no closed-form solution, so we optimize with gradient descent. For multiclass problems you use softmax (multinomial logistic regression) or a one-vs-rest scheme.

**When to use:** Binary or multiclass classification where you want probability outputs and interpretable feature effects, like credit risk or churn.

**Trade-offs:** Interpretable, well-calibrated probabilities, fast, but the decision boundary is linear so it can't capture complex interactions without feature engineering.

**Follow-ups:**
- "Why not use MSE as the loss?" With the sigmoid, MSE becomes non-convex and has vanishing gradients, so optimization stalls. Log loss is convex here and gives strong gradients when the model is confidently wrong.
- "How do you read the coefficients?" Each coefficient is the change in log-odds per unit change in the feature. Exponentiate it to get an odds ratio.
- "How do you handle class imbalance?" Class weights, resampling (SMOTE or undersampling), or adjusting the decision threshold based on the precision-recall trade-off you care about.

---

### 3. Decision Tree

**Interview answer:**
"A decision tree splits the data into regions using a series of if/else questions on the features. At each node it picks the feature and threshold that best separates the data. For classification the split quality is measured by Gini impurity or entropy, and for regression by variance reduction. You keep splitting until a stopping condition, then each leaf makes a prediction."

**How it works, deeper:**
At every node the algorithm greedily evaluates candidate splits and chooses the one that most reduces impurity. It's greedy because it optimizes locally at each node, not globally. Left unconstrained it will keep splitting until every leaf is pure, which memorizes the training data.

**When to use:** You need an interpretable model, have mixed numeric and categorical features, or want to capture non-linear relationships without scaling.

**Trade-offs:** Highly interpretable and needs no feature scaling, but overfits easily and is unstable, meaning a small change in data can produce a very different tree.

**Follow-ups:**
- "Gini versus entropy?" Both measure node impurity and usually produce similar trees. Gini is slightly faster because it avoids the logarithm; entropy can give marginally more balanced splits. In practice the choice rarely matters.
- "How do you prevent overfitting?" Limit max depth, set a minimum samples per leaf or per split, or prune the tree after growing it (cost-complexity pruning).
- "Why is it called greedy?" Because it makes the locally optimal split at each node without reconsidering earlier splits, so it doesn't guarantee a globally optimal tree.

---

### 4. Random Forest

**Interview answer:**
"Random forest is an ensemble of decision trees that reduces the overfitting a single tree suffers from. It uses two sources of randomness: each tree is trained on a bootstrap sample of the data (bagging), and at each split only a random subset of features is considered. The final prediction is the average for regression or the majority vote for classification."

**How it works, deeper:**
Bagging means sampling the training set with replacement, so each tree sees a slightly different dataset. Restricting the features at each split decorrelates the trees, which is the key trick. If you only bootstrapped, the trees would still be similar because strong features would dominate every tree; random feature selection breaks that. Averaging many decorrelated, individually high-variance trees cancels their errors and lowers overall variance.

**When to use:** Excellent general-purpose baseline for tabular data, especially when you want good accuracy with minimal tuning.

**Trade-offs:** Robust, hard to overfit, gives feature importance, but less interpretable than a single tree and heavier at inference time.

**Follow-ups:**
- "How does it reduce variance without increasing bias much?" Each tree is low-bias and high-variance. Averaging independent estimators keeps the bias roughly the same but divides the variance, and decorrelation is what makes the averaging effective.
- "What is out-of-bag error?" Since each tree omits about a third of the data during bootstrapping, those held-out samples act as a built-in validation set, giving a free cross-validation-like estimate.
- "How do you get feature importance?" By measuring the total impurity reduction each feature contributes, or more reliably via permutation importance.

---

### 5. Gradient Boosting (XGBoost / LightGBM / CatBoost)

**Interview answer:**
"Gradient boosting builds trees sequentially, where each new tree corrects the errors of the ensemble so far. Concretely, each tree is fit to the negative gradient of the loss function, which for squared error is just the residuals. You add trees one at a time, each scaled by a learning rate, so the model gradually improves. XGBoost, LightGBM, and CatBoost are optimized implementations of this idea."

**How it works, deeper:**
Start with a simple prediction, like the mean. Compute the residuals, fit a small tree to them, add its scaled output to the prediction, then repeat. The learning rate shrinks each tree's contribution so no single tree dominates, which improves generalization but needs more trees. Modern libraries add regularization, handle missing values, and parallelize the tree construction.

**When to use:** When you want top accuracy on structured/tabular data. It wins a large share of Kaggle competitions.

**Trade-offs:** State-of-the-art accuracy on tabular data, but more prone to overfitting than random forest, sensitive to hyperparameters, and slower to train sequentially.

**Follow-ups:**
- "Bagging versus boosting?" Bagging trains trees in parallel on random subsets to reduce variance. Boosting trains trees sequentially, each focused on the prior errors, to reduce bias. Boosting usually gets higher accuracy but is easier to overfit.
- "Random forest versus gradient boosting?" Forests are safer and easier to tune; boosting typically wins on accuracy when tuned. Forests parallelize; boosting is sequential.
- "What are the key hyperparameters?" Learning rate, number of trees, max depth, and regularization terms. Lower learning rate with more trees generally generalizes better.
- "Why does LightGBM train faster?" It grows trees leaf-wise rather than level-wise and uses histogram-based binning of feature values.

---

### 6. Support Vector Machine (SVM)

**Interview answer:**
"An SVM finds the hyperplane that separates the classes with the maximum margin, meaning the widest possible gap between the boundary and the nearest points of each class. Those nearest points are the support vectors and they alone define the boundary. For data that isn't linearly separable, the kernel trick maps it into a higher-dimensional space where a linear separator exists."

**How it works, deeper:**
Maximizing the margin gives better generalization. A soft margin allows some misclassifications, controlled by the C parameter, which trades off margin width against training errors. The kernel trick computes dot products in a high-dimensional space without ever explicitly transforming the data, so non-linear boundaries become cheap. Common kernels are linear, polynomial, and RBF (Gaussian).

**When to use:** Small-to-medium datasets, high-dimensional data such as text, and cases with a clear margin of separation.

**Trade-offs:** Effective in high dimensions and memory-efficient (only stores support vectors), but slow on large datasets, sensitive to kernel and parameter choice, and doesn't output probabilities natively.

**Follow-ups:**
- "Explain the kernel trick simply." It lets you compute the similarity between points as if they were in a much higher-dimensional space, without paying the cost of actually moving them there. That's what enables non-linear separation efficiently.
- "What do C and gamma do?" C controls the margin-versus-error trade-off; high C means fewer training errors but risk of overfitting. Gamma (in RBF) controls how far each point's influence reaches; high gamma means tight, wiggly boundaries.
- "Why does it struggle on large data?" Training scales roughly quadratically to cubically with the number of samples.

---

### 7. K-Nearest Neighbors (KNN)

**Interview answer:**
"KNN is a lazy, instance-based algorithm. There's no real training phase; it just stores the data. To classify a new point it finds the K closest points by some distance metric, usually Euclidean, and takes a majority vote of their labels. For regression it averages the neighbors' values."

**How it works, deeper:**
All the computation happens at prediction time, which is why it's called lazy. The choice of K controls the bias-variance trade-off: a small K is sensitive to noise (high variance), while a large K smooths the boundary but can blur real distinctions (higher bias). Feature scaling is essential because distance is dominated by large-magnitude features otherwise.

**When to use:** Small, low-dimensional datasets, or as a simple baseline. Also useful for recommendation-style similarity lookups.

**Trade-offs:** Simple and non-parametric with no training cost, but slow and memory-heavy at inference, sensitive to scaling and irrelevant features, and degrades badly in high dimensions.

**Follow-ups:**
- "How do you choose K?" Cross-validation. Use an odd K for binary classification to avoid tie votes. Plot validation error against K and pick the elbow.
- "Why does it suffer from the curse of dimensionality?" In high dimensions all points become roughly equidistant, so 'nearest' loses meaning and the votes become unreliable.
- "How do you speed it up?" Use spatial data structures like KD-trees or Ball-trees, or approximate nearest neighbor methods.

---

### 8. Naive Bayes

**Interview answer:**
"Naive Bayes is a probabilistic classifier based on Bayes' theorem. It computes the probability of each class given the features and picks the highest. The 'naive' part is the assumption that all features are conditionally independent given the class, which lets us just multiply the individual feature probabilities together."

**How it works, deeper:**
By Bayes' theorem, the posterior is proportional to the prior times the likelihood. The independence assumption turns the joint likelihood into a simple product of per-feature likelihoods, which is why it's so fast and works even with limited data. Variants match the data: Gaussian for continuous features, Multinomial for counts (text), and Bernoulli for binary features.

**When to use:** Text classification, spam filtering, sentiment analysis, and any high-dimensional sparse setting where speed matters.

**Trade-offs:** Extremely fast, works with little data, strong on text, but the independence assumption is usually false, so probability estimates can be poorly calibrated even when the classification is correct.

**Follow-ups:**
- "The independence assumption is unrealistic. Why does it still work?" Even when features are correlated, the class with the highest probability is often still ranked correctly, so classification accuracy holds up even if the probabilities themselves are off.
- "What is Laplace smoothing?" Adding a small count to every feature-class combination so that an unseen feature value doesn't produce a zero probability that wipes out the whole product.

---

## UNSUPERVISED LEARNING

---

### 9. K-Means Clustering

**Interview answer:**
"K-means partitions data into K clusters by minimizing the within-cluster sum of squared distances to the cluster centers. It works iteratively: initialize K centroids, assign each point to its nearest centroid, recompute each centroid as the mean of its assigned points, and repeat until assignments stop changing."

**How it works, deeper:**
It's an expectation-maximization style loop: the assignment step and the update step alternate until convergence. It's guaranteed to converge but only to a local optimum, so results depend on initialization. K-means++ seeds the initial centroids spread apart to avoid poor solutions. It implicitly assumes clusters are spherical and similarly sized.

**When to use:** Customer segmentation, image compression, or any exploratory grouping where clusters are roughly convex.

**Trade-offs:** Fast and scalable, but you must choose K upfront, it's sensitive to initialization and outliers, and it fails on elongated or unevenly sized clusters.

**Follow-ups:**
- "How do you choose K?" The elbow method plots inertia against K and looks for the bend. The silhouette score measures how well-separated clusters are. Sometimes domain knowledge sets K directly.
- "Why run it multiple times?" Because it converges to local optima, so you run several random initializations and keep the best (lowest inertia). K-means++ reduces this problem.
- "When does it fail?" Non-spherical clusters, varying densities, or clusters of very different sizes. DBSCAN or Gaussian Mixture Models handle those better.

---

### 10. Hierarchical Clustering

**Interview answer:**
"Hierarchical clustering builds a tree of nested clusters called a dendrogram. The common agglomerative approach starts with every point as its own cluster and repeatedly merges the two closest clusters until everything is in one. You then cut the dendrogram at a chosen height to get your clusters."

**How it works, deeper:**
The definition of 'closest' depends on the linkage criterion. Single linkage uses the minimum distance between clusters and can produce long chains; complete linkage uses the maximum and gives compact clusters; average linkage uses the mean; and Ward's method merges the pair that increases total within-cluster variance the least, which tends to give balanced clusters. Unlike K-means you don't specify the cluster count in advance; you decide it by where you cut the tree.

**When to use:** When you want to see a hierarchy of groupings, don't know the number of clusters, and have a smaller dataset.

**Trade-offs:** No need to pre-specify K and the dendrogram is interpretable, but it's computationally expensive (at least quadratic) so it doesn't scale, and merges are irreversible.

**Follow-ups:**
- "K-means versus hierarchical?" K-means is fast and needs K upfront; hierarchical is slower but reveals structure at all levels and lets you choose K afterward.
- "Which linkage should you use?" Ward's is a solid default for compact clusters. Single linkage is prone to chaining.

---

### 11. DBSCAN

**Interview answer:**
"DBSCAN is a density-based clustering algorithm. It groups together points that are packed closely, and marks points in low-density regions as noise. It has two parameters: epsilon, the neighborhood radius, and min_samples, the minimum number of points needed to form a dense region. It's great because it finds arbitrarily shaped clusters and detects outliers automatically."

**How it works, deeper:**
It labels points as core (enough neighbors within epsilon), border (within a core point's neighborhood but not itself dense), or noise (neither). Clusters grow by connecting core points and their reachable neighbors. Crucially, you don't specify the number of clusters; the density structure determines it.

**When to use:** Clusters of arbitrary shape, unknown cluster count, or when you specifically need outlier/anomaly detection.

**Trade-offs:** Finds non-convex shapes and handles noise, no need to set K, but struggles when clusters have very different densities and is sensitive to the epsilon and min_samples settings.

**Follow-ups:**
- "K-means versus DBSCAN?" K-means needs K, assumes spherical clusters, and forces every point into a cluster. DBSCAN infers the count, handles arbitrary shapes, and isolates noise.
- "How do you pick epsilon?" Plot the distance to each point's k-th nearest neighbor, sort it, and look for the 'knee' in the curve.
- "Where does it fail?" When cluster densities vary a lot, a single epsilon can't fit all of them. HDBSCAN addresses this.

---

### 12. PCA (Principal Component Analysis)

**Interview answer:**
"PCA is a dimensionality reduction technique. It finds new axes, called principal components, that are orthogonal directions of maximum variance in the data, then projects the data onto the top few. The first component captures the most variance, the second the next most while being perpendicular to the first, and so on. You keep enough components to retain most of the variance while cutting dimensions."

**How it works, deeper:**
You standardize the features, compute the covariance matrix, and find its eigenvectors and eigenvalues, or equivalently apply SVD. The eigenvectors are the principal components and the eigenvalues tell you how much variance each explains. You typically keep enough components to retain something like 95 percent of total variance.

**When to use:** Reduce dimensionality before modeling, remove multicollinearity, visualize high-dimensional data in 2D or 3D, or speed up training.

**Trade-offs:** Removes correlation and reduces overfitting and compute, but the new components aren't interpretable, it only captures linear structure, and it requires scaled features.

**Follow-ups:**
- "Is PCA supervised?" No, it ignores labels entirely and only looks at feature variance. If you want a supervised projection that maximizes class separation, use LDA.
- "Why standardize first?" Otherwise features with larger scales dominate the variance and hijack the components.
- "How many components do you keep?" Look at the cumulative explained variance and keep enough to reach your threshold, or use a scree plot and find the elbow.
- "What's a limitation?" It only finds linear structure. For non-linear manifolds use kernel PCA, t-SNE, or UMAP (the latter two mainly for visualization).

---

## CORE CONCEPTS THAT COME UP CONSTANTLY

---

### Bias-Variance Tradeoff
"Bias is error from wrong assumptions, causing underfitting; the model is too simple to capture the pattern. Variance is error from sensitivity to the training data, causing overfitting; the model memorizes noise. Total error is bias squared plus variance plus irreducible noise. As you increase model complexity, bias falls but variance rises, so you tune for the sweet spot that minimizes total error, typically using cross-validation."

### How to Prevent Overfitting
"Several levers: get more training data, simplify the model, apply regularization like L1 or L2, use cross-validation to detect it, and use model-specific tools like pruning for trees, dropout and early stopping for neural networks, and ensembling. The core idea is to stop the model from fitting noise."

### L1 versus L2 Regularization
"Both add a penalty on the weights to the loss. L1 (Lasso) penalizes the absolute value of weights and drives some exactly to zero, so it performs feature selection. L2 (Ridge) penalizes squared weights and shrinks them smoothly toward zero without eliminating them, which handles multicollinearity well. Elastic Net combines both."

### Precision versus Recall
"Precision asks: of the points I predicted positive, how many were actually positive. Recall asks: of all the actual positives, how many did I catch. There's a trade-off between them, and F1 is their harmonic mean. Optimize precision when false positives are costly, like spam filtering flagging real email. Optimize recall when false negatives are costly, like cancer screening or fraud detection."

### Confusion Matrix and ROC-AUC
"The confusion matrix breaks predictions into true positives, false positives, true negatives, and false negatives, and every classification metric derives from it. ROC-AUC plots the true positive rate against the false positive rate across all thresholds; AUC is the area under that curve and measures how well the model ranks positives above negatives, independent of any single threshold. It's useful but can look optimistic on heavily imbalanced data, where precision-recall AUC is more honest."

### Bagging versus Boosting
"Both are ensemble methods. Bagging trains many models in parallel on random subsets and averages them to reduce variance; Random Forest is the classic example. Boosting trains models sequentially, each correcting the previous one's mistakes, to reduce bias; XGBoost is the classic example. Bagging is safer against overfitting; boosting usually reaches higher accuracy when tuned."

### Generative versus Discriminative Models
"Generative models learn the joint distribution of features and labels, so they model how the data is generated; Naive Bayes is an example. Discriminative models learn the boundary between classes directly by modeling the probability of the label given the features; Logistic Regression and SVM are examples. Discriminative models usually classify better; generative models can generate data and cope better with missing features."

### Curse of Dimensionality
"As the number of features grows, the volume of the space grows exponentially, so data becomes sparse and distance metrics lose meaning, since everything ends up roughly equidistant. Models then need exponentially more data to generalize. The fixes are dimensionality reduction like PCA, feature selection, and regularization."

### Cross-Validation
"Instead of a single train-test split, K-fold cross-validation splits the data into K parts, trains on K-1 and validates on the remaining one, then rotates so each fold is validated once. Averaging the results gives a more reliable performance estimate and reduces the luck of a single split. Stratified K-fold preserves class proportions, which matters for imbalanced data."

### Generalization: How Do You Know a Model Will Perform in Production
"Evaluate on a held-out test set the model never saw, monitor for train-versus-validation gap to catch overfitting, watch for data drift over time, and validate on the actual business metric, not just the ML metric. A model can have great AUC and still fail if the deployment distribution differs from training."
