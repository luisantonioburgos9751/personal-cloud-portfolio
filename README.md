# Personal Cloud Portfolio

A serverless personal portfolio hosted on AWS, with infrastructure managed through Terraform, automated code validation, and repeatable deployments.

**Live Website:** https://d3e94t96gv66gp.cloudfront.net/

## Problem Statement

A technical professional needs to publish and maintain a portfolio securely, with reliable availability, controlled costs, repeatable updates, and without managing servers.

This project implements a cloud-hosted solution using managed AWS services.

## Architecture

**Visitor → HTTPS → Amazon CloudFront → Origin Access Control → Private Amazon S3 Bucket**

- **Amazon S3:** Stores the static website files.
- **Amazon CloudFront:** Delivers the website over HTTPS.
- **Origin Access Control (OAC):** Restricts access to the private S3 origin.
- **Terraform:** Manages the existing website infrastructure.
- **Amazon S3 Backend:** Stores Terraform state remotely.
- **GitHub Actions:** Validates website files automatically.
- **PowerShell + AWS CLI:** Automate website deployment and cache invalidation.

## Technology Stack

| Category | Technologies |
|---|---|
| Cloud | AWS S3, CloudFront, IAM |
| Infrastructure as Code | Terraform |
| CI | GitHub Actions |
| Deployment | PowerShell, AWS CLI |
| Web | HTML5, CSS3 |
| Code Quality | HTMLHint, Stylelint |
| Version Control | Git, GitHub |

## Implementation

### 1. Secure Static Hosting

The website is stored in a private Amazon S3 bucket.

S3 Block Public Access is enabled, and CloudFront uses Origin Access Control to retrieve the website files.

Visitors access the website through CloudFront instead of directly accessing S3 objects.

### 2. Infrastructure as Code

Existing AWS resources were imported into Terraform.

Terraform manages the S3 website bucket, its access configuration, CloudFront distribution, and Origin Access Control.

Terraform state is stored remotely in a separate S3 bucket with versioning and encryption enabled. S3 state locking is configured.

### 3. Continuous Integration

A GitHub Actions workflow runs when a Pull Request targets `main`.

The workflow:

- Verifies that website files exist and are not empty.
- Validates HTML using HTMLHint.
- Validates CSS using Stylelint.
- Reports validation results before merging.

### 4. Repeatable Deployment

A PowerShell script automates the website deployment process.

Run from the repository root:

```powershell
.\scripts\deploy.ps1
```

The script verifies AWS authentication, uploads the website files to S3, and requests a CloudFront cache invalidation.

Deployment currently requires manual execution from an authenticated environment.

## Validation Results

The following checks were completed during implementation:

- Direct anonymous access to website objects in S3 was denied.
- The website was accessible through CloudFront.
- Terraform recognized the imported infrastructure without proposing changes.
- Terraform state was verified in the remote S3 backend.
- GitHub Actions successfully completed HTML and CSS checks.
- Both website files were uploaded through the deployment script.
- CloudFront invalidation reached `Completed`.
- The website homepage and CSS resource returned HTTP `200 OK`.

## Security Considerations

- S3 Block Public Access enabled.
- Object ACLs disabled.
- CloudFront OAC with signed requests.
- Bucket policy restricted to the intended CloudFront distribution.
- Terraform state excluded from Git tracking.
- Temporary AWS authentication used for deployment.
- No permanent AWS access keys required by the deployment script.

## Current Limitations

- Deployment is initiated locally, not automatically from GitHub Actions.
- The deployment script handles only the two current website files.
- Automatic rollback is not implemented.
- The script does not wait for CloudFront invalidation completion.
- Availability and long-term operating costs have not yet been measured.
- Full infrastructure reconstruction from an empty AWS account has not been validated.

## Documentation

- [Deployment Guide](docs/deployment.md)
- [S3 Security Validation — SEG-01](docs/seg-01.md)
- [Terraform Infrastructure](infrastructure/)
- [Deployment Script](scripts/deploy.ps1)
- [CI Workflow](.github/workflows/ci.yml)

## Project Status

**Functional MVP — final hardening and documentation in progress.**

The project demonstrates practical experience with AWS static hosting, infrastructure management, cloud security, continuous integration, and repeatable deployment.