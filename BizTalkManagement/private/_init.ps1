# Get local BizTalk DBName and DB Server from WMI
$btsSettings = get-wmiobject MSBTS_GroupSetting -namespace 'root\MicrosoftBizTalkServer'
$dbInstance = $btsSettings.MgmtDbServerName
$dbName = $btsSettings.MgmtDbName

# Load BizTalk ExplorerOM
[void] [System.reflection.Assembly]::LoadWithPartialName("Microsoft.BizTalk.ExplorerOM")
$Script:BizTalkOM = New-Object Microsoft.BizTalk.ExplorerOM.BtsCatalogExplorer
$Script:BizTalkOM.ConnectionString = "SERVER=$dbInstance;DATABASE=$dbName;Integrated Security=SSPI"

