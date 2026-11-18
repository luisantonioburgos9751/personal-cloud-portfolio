# Deployment Guide — Personal Cloud Portfolio

## 1. Overview

This project uses a PowerShell script to deploy a static website to Amazon S3 and refresh its content through Amazon CloudFront.

The deployment process is repeatable and does not require manually uploading files through the AWS Management Console.

**Architecture:**
- **Amazon S3:** Stores the website files.
- **Amazon CloudFront:** Delivers the website over HTTPS.
- **AWS CLI:** Executes deployment operations.
- **PowerShell:** Automates the deployment process.
- **Terraform:** Manages the existing AWS infrastructure.

## 2. Prerequisites

Before running the deployment script, ensure the following requirements are met:

- PowerShell installed.
- AWS CLI installed and configured.
- An authenticated AWS CLI profile named `personal-cloud-portfolio`.
- Permission to upload objects to the website's S3 bucket.
- Permission to create CloudFront invalidations.
- A local copy of the repository containing `index.html`, `styles.css`, and `scripts/deploy.ps1`.

**AWS resources:**

- S3 bucket: `personal-cloud-portfolio-web-141353495450-us-east-2-an`
- CloudFront distribution ID: `E2MNF1NIR58MVI`
- AWS region for the S3 bucket: `us-east-2`

Git is useful for obtaining and updating the repository. Node.js is used by the CI workflow but is not required to execute the deployment script.

## 3. How to Deploy

### Step 1 — Verify AWS authentication

If the AWS session has expired, renew it:

```powershell
aws login --profile personal-cloud-portfolio --region us-east-2
```

Verify the active AWS identity:

```powershell
aws sts get-caller-identity --profile personal-cloud-portfolio
```

### Step 2 — Run the deployment script

Open PowerShell in the root directory of the project and execute:

```powershell
.\scripts\deploy.ps1
```

The script performs these operations:

1. Verifies that `index.html` and `styles.css` exist locally.
2. Checks AWS authentication using `sts get-caller-identity`.
3. Uploads `index.html` to the S3 website bucket.
4. Uploads `styles.css` to the same bucket.
5. Requests a CloudFront cache invalidation for `/`, `/index.html`, and `/styles.css`.
6. Stops execution if an AWS CLI command reports an error.

The script uses an existing AWS CLI profile and does not store AWS access keys in the repository.

## 4. Validation

After deployment, verify that CloudFront has completed the invalidation.

### CloudFront invalidation

Check the invalidation status using its returned ID:

```powershell
aws cloudfront get-invalidation --distribution-id E2MNF1NIR58MVI --id INVALIDATION_ID --profile personal-cloud-portfolio --query "Invalidation.Status" --output text
```

Replace `INVALIDATION_ID` with the ID returned by the deployment script.

The expected final status is:

```text
Completed
```

### Website availability

Verify the website response:

```powershell
curl.exe -I https://d3e94t96gv66gp.cloudfront.net/
```

Verify the CSS file:

```powershell
curl.exe -I https://d3e94t96gv66gp.cloudfront.net/styles.css
```

Both requests should return HTTP status `200 OK`.

These checks confirm that the files are accessible through CloudFront. They do not independently verify that the published content is identical to the local files.

## 5. Continuous Integration

The repository includes a GitHub Actions workflow at:

`.github/workflows/ci.yml`

When a Pull Request targets `main`, the CI workflow:

1. Checks out the repository.
2. Configures Node.js.
3. Verifies that the website files exist and are not empty.
4. Runs HTMLHint to analyze `index.html`.
5. Installs project dependencies.
6. Runs Stylelint to analyze `styles.css`.

These checks help identify problems before changes are merged.

## 6. Limitations

The current implementation has the following limitations:

- **Manual execution:** Deployment must be initiated from a machine with a valid AWS CLI session.
- **No GitHub-based deployment:** GitHub Actions performs CI checks but does not deploy to AWS.
- **Limited scope:** The script uploads only `index.html` and `styles.css`.
- **Asynchronous invalidation:** The script requests CloudFront invalidation but does not wait for the final `Completed` status.
- **No automatic rollback:** The script does not restore a previous release if deployment fails.
- **Partial deployment risk:** Files are uploaded individually, so a failed second upload could leave a partially updated website.
- **Basic local validation:** The script checks file existence but does not check file contents or run HTMLHint and Stylelint.

The deployment process was designed to work within the AWS account's current IAM restrictions without storing permanent AWS credentials.

## 7. Verified Results

The following results were confirmed during implementation on November 18, 2026:

- Successful authentication through AWS CLI.
- Successful upload of both website files to Amazon S3.
- CloudFront invalidation reached `Completed`.
- Website homepage returned HTTP `200 OK`.
- CSS resource returned HTTP `200 OK`.
- The deployment script was committed to the GitHub repository.

**Public website:** https://d3e94t96gv66gp.cloudfront.net/

## 8. Future Improvements

Potential improvements include:

- Stronger pre-deployment validation.
- Automatic confirmation of CloudFront invalidation completion.
- Deployment versioning and rollback capabilities.
- Secure GitHub Actions deployment when the AWS account permits suitable authentication.

The current solution provides a functional, repeatable local deployment process for the cloud-hosted portfolio.