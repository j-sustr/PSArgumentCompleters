$modulePath = Get-ModulePath PSArgumentCompleters -LatestVersion
$manifestPath = Convert-Path $PSScriptRoot\src\*.psd1

function getPSMemoDllPath() {
    $psMemoModulePath = Get-ModulePath PSMemo -LatestVersion
    return Join-Path $psMemoModulePath 'PSMemo.dll'
}

$psMemoDllPath = getPSMemoDllPath

$updateParams = @{
    Path               = $manifestPath
    RequiredAssemblies = @( $psMemoDllPath )
}

Push-Location $modulePath
Update-ModuleManifest @updateParams
Pop-Location



