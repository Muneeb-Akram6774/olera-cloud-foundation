# Terraform Backend Bootstrap

This directory creates the small set of AWS resources required to host Terraform remote state before the main infrastructure can use that backend. It is intentionally separate from the main environment configuration because Terraform cannot use an S3 backend to manage the very bucket that must exist before the backend can initialize; that is the classic bootstrap (chicken-and-egg) problem.

The bootstrap itself intentionally uses Terraform local state as a one-time exception. After this layer exists, the `dev` and `prod` environments use the shared S3 bucket for remote state, with separate keys so their state remains isolated.

The S3 bucket has versioning, server-side encryption, Block Public Access, and Bucket Owner Enforced object ownership enabled. A DynamoDB table with a `LockID` string partition key is also created to match the traditional Terraform S3+DynamoDB locking pattern used by many existing platforms.

> Modern Terraform note: native S3 state locking with `use_lockfile = true` is now preferred; DynamoDB locking is deprecated in current Terraform versions. The environment backend files in this project enable native S3 locking and retain the DynamoDB reference for compatibility/legacy-pattern demonstration.