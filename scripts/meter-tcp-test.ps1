# 电表网口 NDJSON 联调：向本机 TCP 端口发送一行 JSON（需先启动应用并开启 meter.modbus.tcp-enabled）
# 用法（PowerShell）:
#   .\scripts\meter-tcp-test.ps1
#   .\scripts\meter-tcp-test.ps1 -Port 5021 -ServerHost 127.0.0.1
# 若配置了 ingest-api-key，先设置环境变量:
#   $env:METER_TCP_KEY = "你的密钥"

param(
    [string] $ServerHost = "127.0.0.1",
    [int] $Port = 5021
)

$payload = @{
    slaveId       = 1
    registerType  = 0
    baseAddress   = 0
    registers     = @(100, 200, 300)
    readTime      = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
} | ConvertTo-Json -Compress

$client = New-Object System.Net.Sockets.TcpClient
try {
    $client.Connect($ServerHost, $Port)
    $stream = $client.GetStream()
    $writer = New-Object System.IO.StreamWriter($stream, [System.Text.Encoding]::UTF8)
    $writer.NewLine = "`n"
    if ($env:METER_TCP_KEY) {
        $writer.WriteLine("KEY:$($env:METER_TCP_KEY)")
    }
    $writer.WriteLine($payload)
    $writer.Flush()
    Write-Host "已发送: $payload"
    Write-Host "若应用日志无报错且点表已配置，应写入 meter_sample。"
}
finally {
    if ($client.Connected) { $client.Close() }
}
