param(
  [ValidateSet("serve","build","gh-deploy")]
  [string]$Task = "serve",
  [int]$Port = 8000
)

$ErrorActionPreference = "Stop"

Push-Location $PSScriptRoot
try {
  if (-not (Test-Path .\requirements.txt)) {
    throw "requirements.txt not found. Run this script inside the my-wiki directory."
  }

  python -m pip install --upgrade pip | Out-Null
  pip install -r requirements.txt

  switch ($Task) {
    "serve" {
      python -m mkdocs serve -a ("127.0.0.1:{0}" -f $Port)
    }
    "build" {
      python -m mkdocs build --clean
      Write-Host "Built to: $PSScriptRoot\\site"
    }
    "gh-deploy" {
      python -m mkdocs gh-deploy
    }
  }
}
finally {
  Pop-Location
}
