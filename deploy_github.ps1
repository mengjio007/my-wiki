param(
  # Commit message. If empty, uses a timestamp message.
  [string]$Message = "",

  # When there are source changes, auto-commit them before deploy.
  [switch]$AutoCommit = $true,

  # Push main branch before gh-deploy (recommended).
  [switch]$PushMain = $true
)

$ErrorActionPreference = "Stop"

function Invoke-Git {
  param([Parameter(ValueFromRemainingArguments=$true)][object[]]$Args)
  $repo = (Resolve-Path $PSScriptRoot).Path.Replace('\','/')
  & git -c ("safe.directory={0}" -f $repo) @Args
  if ($LASTEXITCODE -ne 0) { throw "git failed: $Args" }
}

Push-Location $PSScriptRoot
try {
  if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "git not found in PATH" }
  if (-not (Get-Command python -ErrorAction SilentlyContinue)) { throw "python not found in PATH" }

  # Ensure build output doesn't pollute source commits.
  if (-not (Test-Path .\.gitignore)) {
    "@`nsite/`n" | Out-File -Encoding utf8 .\.gitignore
  } else {
    $gi = Get-Content -Raw -Encoding utf8 .\.gitignore
    if ($gi -notmatch "(?m)^\s*site/\s*$") {
      "`nsite/`n" | Out-File -Append -Encoding utf8 .\.gitignore
    }
  }

  # If `site/` was previously tracked, untrack it (keep files on disk).
  $trackedSite = (Invoke-Git @("ls-files","--","site")) -join "`n"
  if ($trackedSite.Trim().Length -gt 0) {
    Invoke-Git @("rm","-r","--cached","--ignore-unmatch","site") | Out-Null
  }

  # Install deps (user site-packages is fine on Windows).
  python -m pip install -r requirements.txt | Out-Null

  # Commit source changes (excluding site/ which is ignored/untracked above).
  $status = (Invoke-Git @("status","--porcelain")) -join "`n"
  if ($status.Trim().Length -gt 0) {
    if (-not $AutoCommit) {
      throw "Working tree has changes. Commit them or re-run with -AutoCommit."
    }
    if ([string]::IsNullOrWhiteSpace($Message)) {
      $Message = ("Deploy: {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
    }
    Invoke-Git @("add","-A")
    Invoke-Git @("commit","-m",$Message) | Out-Null
  }

  if ($PushMain) {
    Invoke-Git @("push","origin","main") | Out-Null
  }

  # Deploy to gh-pages.
  python -m mkdocs gh-deploy --clean
}
finally {
  Pop-Location
}
