param(
    [string]$Message = "update: new version"
)

Write-Host "Building web app..." -ForegroundColor Cyan
flutter build web --no-tree-shake-icons --no-wasm-dry-run
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne 1) {
    Write-Host "Build failed. Aborting." -ForegroundColor Red
    exit 1
}

Write-Host "Committing and pushing..." -ForegroundColor Cyan
git add -A
git commit -m $Message
git push origin main

Write-Host "Done! Render will auto-deploy in ~2-4 minutes." -ForegroundColor Green
Write-Host "Monitor at: https://dashboard.render.com" -ForegroundColor Yellow
