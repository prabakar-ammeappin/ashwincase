The ubuntu or the databricks/minimal base image doesn't support all the features in the notebook. So using the standard image will help to resolve the problem.

Standard Container: This image is intended to have feature parity with the current Databricks Runtime. Support for features will be added over time.

Supported Features: Scala Notebooks, Java/Jar jobs, Python Notebooks, Python Jobs, Spark Submit Jobs, %sh, DBFS FUSE mount (/dbfs), SSH

Unsupported Features: Ganglia

Minimal Container: This image is the smallest example of what is necessary to launch a cluster in Databricks. This is intended for users who know exactly what they need and do not need.

Supported Features: Scala Notebooks, Java/Jar jobs

Unsupported Features: Python Notebooks, Python Jobs, Spark Submit Jobs, %sh, DBFS FUSE mount (/dbfs), SSH, Ganglia
