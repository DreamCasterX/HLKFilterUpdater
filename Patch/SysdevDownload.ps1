param (
    $source = "https://aka.ms/HLKFilters",
    $dest = "C:\Users\Administrator\Desktop\HLKFilterUpdater\NewFilter\Updatefilters.cab",
    [switch]$quiet = $false,
    [switch]$help = $false
)

$usage = @"

Usage:  SysdevDownload.ps1 [-source <web address>]
                           [-dest <filename> ]
                           [-quiet]
                           [-help] [-?]

        -source:  Web address of the file to download
          -dest:  Filename to the same downloaded file
    -?,-h,-help:  print out this usage information

"@

# ---------------------------------------------------------------------------
# Check for a -?, -h, or -help on the command line, and print a usage message
# if they are present.
# ---------------------------------------------------------------------------
if ($help) { 
    write-host $usage 
    exit
}

foreach ($arg in $args) {
    if ($arg -eq "-?") {
        write-host $usage
        exit
    }
}

# Set TLS version
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor 
[Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls

$wc = new-object system.net.webclient

if (-not $quiet) {
    write-host ""
    write-host "Downloading $source"
    write-host "to $dest"
}

$wc.DownloadFile($source, $dest)

if (-not $quiet) {
    write-host ""
    write-host "File downloaded."
    write-host ""
}

