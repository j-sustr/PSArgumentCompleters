
$modulePath = Get-ModulePath PSArgumentCompleters -LatestVersion
$manifestPath = Resolve-Path $PSScriptRoot\src\*.psd1

$psMemoDllPath = getPSMemoDllPath

$updateParams = @{
    Path               = $manifestPath
    RequiredAssemblies = @( $psMemoDllPath )
}

Push-Location $modulePath
Update-ModuleManifest @updateParams
Pop-Location

function getPSMemoDllPath() {
    $psMemoModulePath = Get-ModulePath PSMemo -LatestVersion
    return Join-Path $psMemoModulePath 'PSMemo.dll'
}

