if (${env:RELEASE_ROOT_DIR} -ne $null) {
  Write-Output "Root dir is ${env:RELEASE_ROOT_DIR}"
  Start-Process -FilePath "${env:RELEASE_ROOT_DIR}\bin\chip_api.bat" -ArgumentList "command Elixir.ChipApi.ReleaseTasks seed" -NoNewWindow -Wait
} else {
  Write-Output "The RELEASE_ROOT_DIR environment variable must be set to execute this command."
  Exit 1
}