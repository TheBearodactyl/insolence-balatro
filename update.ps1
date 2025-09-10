param(
  [string]$Owner = "thebearodactyl",
  [string]$Repo = "insolence-lib",
  [string]$DownloadDir = "$PSScriptRoot/lib"
)

function Update-Submodule
{
  Write-Host "Updating git submodules..."
  git submodule update --init --recursive --remote
  Write-Host "Updated local clone of lib repo"
}

function Get-LatestReleaseAssets
{
  param(
    [string]$Owner,
    [string]$Repo,
    [string]$DownloadDir
  )

  $url = "https://api.github.com/repos/$Owner/$Repo/releases/latest"
  Write-Host "Fetching release info from $url..."

  try
  {
    $response = Invoke-RestMethod -Uri $url -UseBasicParsing
  } catch
  {
    Write-Error "Error fetching release info: $_"
    return
  }

  $assets = $response.assets
  if (-not $assets -or $assets.Count -eq 0)
  {
    Write-Host "No assets found in the latest release."
    return
  }

  if (-not (Test-Path -Path $DownloadDir))
  {
    New-Item -ItemType Directory -Path $DownloadDir | Out-Null
  }

  $jobs = @()

  foreach ($asset in $assets)
  {
    $assetUrl = $asset.browser_download_url
    $assetName = $asset.name
    $outputPath = Join-Path $DownloadDir $assetName

    Write-Host "Starting download for $assetName ..."

    $job = Start-Job -ScriptBlock {
      param($url, $path, $name)

      try
      {
        Invoke-WebRequest -Uri $url -OutFile $path -UseBasicParsing
        Write-Output "$name downloaded successfully."
      } catch
      {
        Write-Error "Failed to download $name : $_"
      }
    } -ArgumentList $assetUrl, $outputPath, $assetName

    $jobs += $job
  }

  Write-Host "Waiting for all downloads to finish..."
  $results = Receive-Job -Job (Wait-Job -Job $jobs) -Keep
  $results | ForEach-Object { Write-Host $_ }

  Remove-Job -Job $jobs
}

Update-Submodule
Get-LatestReleaseAssets -Owner $Owner -Repo $Repo -DownloadDir $DownloadDir

Move-Item -Force -Path "$PSScriptRoot\lib\liblibinsolence.so" "$PSScriptRoot\lib\libinsolence.so"
