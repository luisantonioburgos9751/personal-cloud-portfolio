$projectRoot = Split-Path -Parent $PSScriptRoot

if (-not (Test-Path (Join-Path $projectRoot "index.html") -PathType Leaf)) {
    throw "ERROR: No se encontro index.html"
}

if (-not (Test-Path (Join-Path $projectRoot "styles.css") -PathType Leaf)) {
    throw "ERROR: No se encontro styles.css"
}

$awsProfile = "personal-cloud-portfolio"
aws sts get-caller-identity --profile $awsProfile | Out-Null

if($LASTEXITCODE -ne 0) {
    throw "ERROR: No se pudo autenticar con AWS"
}
Write-Host "AWS: Autenticacion correcta"

$webBucket = "personal-cloud-portfolio-web-141353495450-us-east-2-an"
Write-Host "Bucket destino: $webBucket"

$indexPath = Join-Path $projectRoot "index.html"
aws s3 cp $indexPath "s3://$webBucket/index.html" --profile $awsProfile 
if ($LASTEXITCODE -ne 0) {
    throw "ERROR: Fallo la subida de index.html"
}

$cssPath = Join-Path $projectRoot "styles.css"
aws s3 cp $cssPath "s3://$webBucket/styles.css" --profile $awsProfile 

if ($LASTEXITCODE -ne 0) {
    throw "ERROR: Fallo la subida de styles.css"
}

$distributionId = "E2MNF1NIR58MVI"

aws cloudfront create-invalidation --distribution-id $distributionId --paths "/" "/index.html" "/styles.css" --profile $awsProfile --query "Invalidation.{Id:Id,Status:Status}" --output table
if ($LASTEXITCODE -ne 0) {
    throw "ERROR: Fallo la invalidacion de CloudFront"
}