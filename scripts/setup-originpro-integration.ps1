param(
    [string]$MsiPath = $env:ORIGIN_MSI_PATH
)

$ErrorActionPreference = "Stop"

function Find-OriginExecutable {
    $roots = @(
        (Join-Path $env:ProgramFiles "OriginLab"),
        (Join-Path ([Environment]::GetFolderPath("ProgramFilesX86")) "OriginLab")
    ) | Where-Object { $_ -and (Test-Path $_) }

    foreach ($root in $roots) {
        $exe = Get-ChildItem -Path $root -Recurse -File -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -match '^Origin(64)?\.exe$' } |
            Sort-Object FullName -Descending |
            Select-Object -First 1
        if ($exe) { return $exe.FullName }
    }
    return $null
}

$originExe = Find-OriginExecutable

if (-not $originExe -and $MsiPath) {
    if (-not (Test-Path $MsiPath)) {
        throw "ORIGIN_MSI_PATH is set but the MSI file does not exist: $MsiPath"
    }

    Write-Host "Origin is not installed. Installing the supplied OriginLab MSI quietly..."
    $process = Start-Process msiexec.exe `
        -ArgumentList @("/i", "`"$MsiPath`"", "/qn", "/norestart") `
        -Wait -PassThru

    if ($process.ExitCode -notin @(0, 3010)) {
        throw "Origin MSI installation failed with exit code $($process.ExitCode)."
    }

    $originExe = Find-OriginExecutable
}

if (-not $originExe) {
    throw @"
OriginPro is not installed on this runner.

Use a licensed Windows self-hosted GitHub runner labelled:
  self-hosted, Windows, X64, originpro

Either install and activate OriginPro normally on that machine, or place the
official OriginLab MSI on the runner and set ORIGIN_MSI_PATH to its local path.
The repository intentionally does not store the proprietary Origin installer or
license credentials.
"@
}

Write-Host "Origin executable found: $originExe"

python -m pip install --upgrade pip
python -m pip install --upgrade originpro

python -c "import originpro; print('originpro Python bridge imported successfully')"

Write-Host "OriginPro integration is ready. License validity is tested by verify_originpro.py."
