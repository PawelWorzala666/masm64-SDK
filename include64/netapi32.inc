externdef __imp_CredpValidateTargetName:PPROC
CredpValidateTargetName equ <__imp_CredpValidateTargetName>

externdef __imp_DsAddressToSiteNamesA:PPROC
DsAddressToSiteNamesA equ <__imp_DsAddressToSiteNamesA>
  IFNDEF __UNICODE__
    DsAddressToSiteNames equ <__imp_DsAddressToSiteNamesA>
  ENDIF

externdef __imp_DsAddressToSiteNamesExA:PPROC
DsAddressToSiteNamesExA equ <__imp_DsAddressToSiteNamesExA>
  IFNDEF __UNICODE__
    DsAddressToSiteNamesEx equ <__imp_DsAddressToSiteNamesExA>
  ENDIF

externdef __imp_DsAddressToSiteNamesExW:PPROC
DsAddressToSiteNamesExW equ <__imp_DsAddressToSiteNamesExW>
  IFDEF __UNICODE__
    DsAddressToSiteNamesEx equ <__imp_DsAddressToSiteNamesExW>
  ENDIF

externdef __imp_DsAddressToSiteNamesW:PPROC
DsAddressToSiteNamesW equ <__imp_DsAddressToSiteNamesW>
  IFDEF __UNICODE__
    DsAddressToSiteNames equ <__imp_DsAddressToSiteNamesW>
  ENDIF

externdef __imp_DsDeregisterDnsHostRecordsA:PPROC
DsDeregisterDnsHostRecordsA equ <__imp_DsDeregisterDnsHostRecordsA>
  IFNDEF __UNICODE__
    DsDeregisterDnsHostRecords equ <__imp_DsDeregisterDnsHostRecordsA>
  ENDIF

externdef __imp_DsDeregisterDnsHostRecordsW:PPROC
DsDeregisterDnsHostRecordsW equ <__imp_DsDeregisterDnsHostRecordsW>
  IFDEF __UNICODE__
    DsDeregisterDnsHostRecords equ <__imp_DsDeregisterDnsHostRecordsW>
  ENDIF

externdef __imp_DsEnumerateDomainTrustsA:PPROC
DsEnumerateDomainTrustsA equ <__imp_DsEnumerateDomainTrustsA>
  IFNDEF __UNICODE__
    DsEnumerateDomainTrusts equ <__imp_DsEnumerateDomainTrustsA>
  ENDIF

externdef __imp_DsEnumerateDomainTrustsW:PPROC
DsEnumerateDomainTrustsW equ <__imp_DsEnumerateDomainTrustsW>
  IFDEF __UNICODE__
    DsEnumerateDomainTrusts equ <__imp_DsEnumerateDomainTrustsW>
  ENDIF

externdef __imp_DsGetDcCloseW:PPROC
DsGetDcCloseW equ <__imp_DsGetDcCloseW>
  IFDEF __UNICODE__
    DsGetDcClose equ <__imp_DsGetDcCloseW>
  ENDIF

externdef __imp_DsGetDcNameA:PPROC
DsGetDcNameA equ <__imp_DsGetDcNameA>
  IFNDEF __UNICODE__
    DsGetDcName equ <__imp_DsGetDcNameA>
  ENDIF

externdef __imp_DsGetDcNameW:PPROC
DsGetDcNameW equ <__imp_DsGetDcNameW>
  IFDEF __UNICODE__
    DsGetDcName equ <__imp_DsGetDcNameW>
  ENDIF

externdef __imp_DsGetDcNameWithAccountA:PPROC
DsGetDcNameWithAccountA equ <__imp_DsGetDcNameWithAccountA>
  IFNDEF __UNICODE__
    DsGetDcNameWithAccount equ <__imp_DsGetDcNameWithAccountA>
  ENDIF

externdef __imp_DsGetDcNameWithAccountW:PPROC
DsGetDcNameWithAccountW equ <__imp_DsGetDcNameWithAccountW>
  IFDEF __UNICODE__
    DsGetDcNameWithAccount equ <__imp_DsGetDcNameWithAccountW>
  ENDIF

externdef __imp_DsGetDcNextA:PPROC
DsGetDcNextA equ <__imp_DsGetDcNextA>
  IFNDEF __UNICODE__
    DsGetDcNext equ <__imp_DsGetDcNextA>
  ENDIF

externdef __imp_DsGetDcNextW:PPROC
DsGetDcNextW equ <__imp_DsGetDcNextW>
  IFDEF __UNICODE__
    DsGetDcNext equ <__imp_DsGetDcNextW>
  ENDIF

externdef __imp_DsGetDcOpenA:PPROC
DsGetDcOpenA equ <__imp_DsGetDcOpenA>
  IFNDEF __UNICODE__
    DsGetDcOpen equ <__imp_DsGetDcOpenA>
  ENDIF

externdef __imp_DsGetDcOpenW:PPROC
DsGetDcOpenW equ <__imp_DsGetDcOpenW>
  IFDEF __UNICODE__
    DsGetDcOpen equ <__imp_DsGetDcOpenW>
  ENDIF

externdef __imp_DsGetDcSiteCoverageA:PPROC
DsGetDcSiteCoverageA equ <__imp_DsGetDcSiteCoverageA>
  IFNDEF __UNICODE__
    DsGetDcSiteCoverage equ <__imp_DsGetDcSiteCoverageA>
  ENDIF

externdef __imp_DsGetDcSiteCoverageW:PPROC
DsGetDcSiteCoverageW equ <__imp_DsGetDcSiteCoverageW>
  IFDEF __UNICODE__
    DsGetDcSiteCoverage equ <__imp_DsGetDcSiteCoverageW>
  ENDIF

externdef __imp_DsGetForestTrustInformationW:PPROC
DsGetForestTrustInformationW equ <__imp_DsGetForestTrustInformationW>
  IFDEF __UNICODE__
    DsGetForestTrustInformation equ <__imp_DsGetForestTrustInformationW>
  ENDIF

externdef __imp_DsGetSiteNameA:PPROC
DsGetSiteNameA equ <__imp_DsGetSiteNameA>
  IFNDEF __UNICODE__
    DsGetSiteName equ <__imp_DsGetSiteNameA>
  ENDIF

externdef __imp_DsGetSiteNameW:PPROC
DsGetSiteNameW equ <__imp_DsGetSiteNameW>
  IFDEF __UNICODE__
    DsGetSiteName equ <__imp_DsGetSiteNameW>
  ENDIF

externdef __imp_DsMergeForestTrustInformationW:PPROC
DsMergeForestTrustInformationW equ <__imp_DsMergeForestTrustInformationW>
  IFDEF __UNICODE__
    DsMergeForestTrustInformation equ <__imp_DsMergeForestTrustInformationW>
  ENDIF

externdef __imp_DsRoleAbortDownlevelServerUpgrade:PPROC
DsRoleAbortDownlevelServerUpgrade equ <__imp_DsRoleAbortDownlevelServerUpgrade>

externdef __imp_DsRoleCancel:PPROC
DsRoleCancel equ <__imp_DsRoleCancel>

externdef __imp_DsRoleDcAsDc:PPROC
DsRoleDcAsDc equ <__imp_DsRoleDcAsDc>

externdef __imp_DsRoleDcAsReplica:PPROC
DsRoleDcAsReplica equ <__imp_DsRoleDcAsReplica>

externdef __imp_DsRoleDemoteDc:PPROC
DsRoleDemoteDc equ <__imp_DsRoleDemoteDc>

externdef __imp_DsRoleDnsNameToFlatName:PPROC
DsRoleDnsNameToFlatName equ <__imp_DsRoleDnsNameToFlatName>

externdef __imp_DsRoleFreeMemory:PPROC
DsRoleFreeMemory equ <__imp_DsRoleFreeMemory>

externdef __imp_DsRoleGetDatabaseFacts:PPROC
DsRoleGetDatabaseFacts equ <__imp_DsRoleGetDatabaseFacts>

externdef __imp_DsRoleGetDcOperationProgress:PPROC
DsRoleGetDcOperationProgress equ <__imp_DsRoleGetDcOperationProgress>

externdef __imp_DsRoleGetDcOperationResults:PPROC
DsRoleGetDcOperationResults equ <__imp_DsRoleGetDcOperationResults>

externdef __imp_DsRoleGetPrimaryDomainInformation:PPROC
DsRoleGetPrimaryDomainInformation equ <__imp_DsRoleGetPrimaryDomainInformation>

externdef __imp_DsRoleIfmHandleFree:PPROC
DsRoleIfmHandleFree equ <__imp_DsRoleIfmHandleFree>

externdef __imp_DsRoleServerSaveStateForUpgrade:PPROC
DsRoleServerSaveStateForUpgrade equ <__imp_DsRoleServerSaveStateForUpgrade>

externdef __imp_DsRoleUpgradeDownlevelServer:PPROC
DsRoleUpgradeDownlevelServer equ <__imp_DsRoleUpgradeDownlevelServer>

externdef __imp_DsValidateSubnetNameA:PPROC
DsValidateSubnetNameA equ <__imp_DsValidateSubnetNameA>
  IFNDEF __UNICODE__
    DsValidateSubnetName equ <__imp_DsValidateSubnetNameA>
  ENDIF

externdef __imp_DsValidateSubnetNameW:PPROC
DsValidateSubnetNameW equ <__imp_DsValidateSubnetNameW>
  IFDEF __UNICODE__
    DsValidateSubnetName equ <__imp_DsValidateSubnetNameW>
  ENDIF

externdef __imp_I_BrowserDebugCall:PPROC
I_BrowserDebugCall equ <__imp_I_BrowserDebugCall>

externdef __imp_I_BrowserDebugTrace:PPROC
I_BrowserDebugTrace equ <__imp_I_BrowserDebugTrace>

externdef __imp_I_BrowserQueryEmulatedDomains:PPROC
I_BrowserQueryEmulatedDomains equ <__imp_I_BrowserQueryEmulatedDomains>

externdef __imp_I_BrowserQueryOtherDomains:PPROC
I_BrowserQueryOtherDomains equ <__imp_I_BrowserQueryOtherDomains>

externdef __imp_I_BrowserQueryStatistics:PPROC
I_BrowserQueryStatistics equ <__imp_I_BrowserQueryStatistics>

externdef __imp_I_BrowserResetNetlogonState:PPROC
I_BrowserResetNetlogonState equ <__imp_I_BrowserResetNetlogonState>

externdef __imp_I_BrowserResetStatistics:PPROC
I_BrowserResetStatistics equ <__imp_I_BrowserResetStatistics>

externdef __imp_I_BrowserServerEnum:PPROC
I_BrowserServerEnum equ <__imp_I_BrowserServerEnum>

externdef __imp_I_BrowserSetNetlogonState:PPROC
I_BrowserSetNetlogonState equ <__imp_I_BrowserSetNetlogonState>

externdef __imp_I_NetAccountDeltas:PPROC
I_NetAccountDeltas equ <__imp_I_NetAccountDeltas>

externdef __imp_I_NetAccountSync:PPROC
I_NetAccountSync equ <__imp_I_NetAccountSync>

externdef __imp_I_NetDatabaseDeltas:PPROC
I_NetDatabaseDeltas equ <__imp_I_NetDatabaseDeltas>

externdef __imp_I_NetDatabaseRedo:PPROC
I_NetDatabaseRedo equ <__imp_I_NetDatabaseRedo>

externdef __imp_I_NetDatabaseSync2:PPROC
I_NetDatabaseSync2 equ <__imp_I_NetDatabaseSync2>

externdef __imp_I_NetDatabaseSync:PPROC
I_NetDatabaseSync equ <__imp_I_NetDatabaseSync>

externdef __imp_I_NetDfsCreateExitPoint:PPROC
I_NetDfsCreateExitPoint equ <__imp_I_NetDfsCreateExitPoint>

externdef __imp_I_NetDfsCreateLocalPartition:PPROC
I_NetDfsCreateLocalPartition equ <__imp_I_NetDfsCreateLocalPartition>

externdef __imp_I_NetDfsDeleteExitPoint:PPROC
I_NetDfsDeleteExitPoint equ <__imp_I_NetDfsDeleteExitPoint>

externdef __imp_I_NetDfsDeleteLocalPartition:PPROC
I_NetDfsDeleteLocalPartition equ <__imp_I_NetDfsDeleteLocalPartition>

externdef __imp_I_NetDfsFixLocalVolume:PPROC
I_NetDfsFixLocalVolume equ <__imp_I_NetDfsFixLocalVolume>

externdef __imp_I_NetDfsGetFtServers:PPROC
I_NetDfsGetFtServers equ <__imp_I_NetDfsGetFtServers>

externdef __imp_I_NetDfsGetVersion:PPROC
I_NetDfsGetVersion equ <__imp_I_NetDfsGetVersion>

externdef __imp_I_NetDfsIsThisADomainName:PPROC
I_NetDfsIsThisADomainName equ <__imp_I_NetDfsIsThisADomainName>

externdef __imp_I_NetDfsManagerReportSiteInfo:PPROC
I_NetDfsManagerReportSiteInfo equ <__imp_I_NetDfsManagerReportSiteInfo>

externdef __imp_I_NetDfsModifyPrefix:PPROC
I_NetDfsModifyPrefix equ <__imp_I_NetDfsModifyPrefix>

externdef __imp_I_NetDfsSetLocalVolumeState:PPROC
I_NetDfsSetLocalVolumeState equ <__imp_I_NetDfsSetLocalVolumeState>

externdef __imp_I_NetDfsSetServerInfo:PPROC
I_NetDfsSetServerInfo equ <__imp_I_NetDfsSetServerInfo>

externdef __imp_I_NetGetDCList:PPROC
I_NetGetDCList equ <__imp_I_NetGetDCList>

externdef __imp_I_NetGetForestTrustInformation:PPROC
I_NetGetForestTrustInformation equ <__imp_I_NetGetForestTrustInformation>

externdef __imp_I_NetListCanonicalize:PPROC
I_NetListCanonicalize equ <__imp_I_NetListCanonicalize>

externdef __imp_I_NetListTraverse:PPROC
I_NetListTraverse equ <__imp_I_NetListTraverse>

externdef __imp_I_NetLogonControl2:PPROC
I_NetLogonControl2 equ <__imp_I_NetLogonControl2>

externdef __imp_I_NetLogonControl:PPROC
I_NetLogonControl equ <__imp_I_NetLogonControl>

externdef __imp_I_NetLogonGetDomainInfo:PPROC
I_NetLogonGetDomainInfo equ <__imp_I_NetLogonGetDomainInfo>

externdef __imp_I_NetLogonSamLogoff:PPROC
I_NetLogonSamLogoff equ <__imp_I_NetLogonSamLogoff>

externdef __imp_I_NetLogonSamLogon:PPROC
I_NetLogonSamLogon equ <__imp_I_NetLogonSamLogon>

externdef __imp_I_NetLogonSamLogonEx:PPROC
I_NetLogonSamLogonEx equ <__imp_I_NetLogonSamLogonEx>

externdef __imp_I_NetLogonSamLogonWithFlags:PPROC
I_NetLogonSamLogonWithFlags equ <__imp_I_NetLogonSamLogonWithFlags>

externdef __imp_I_NetLogonSendToSam:PPROC
I_NetLogonSendToSam equ <__imp_I_NetLogonSendToSam>

externdef __imp_I_NetLogonUasLogoff:PPROC
I_NetLogonUasLogoff equ <__imp_I_NetLogonUasLogoff>

externdef __imp_I_NetLogonUasLogon:PPROC
I_NetLogonUasLogon equ <__imp_I_NetLogonUasLogon>

externdef __imp_I_NetNameCanonicalize:PPROC
I_NetNameCanonicalize equ <__imp_I_NetNameCanonicalize>

externdef __imp_I_NetNameCompare:PPROC
I_NetNameCompare equ <__imp_I_NetNameCompare>

externdef __imp_I_NetNameValidate:PPROC
I_NetNameValidate equ <__imp_I_NetNameValidate>

externdef __imp_I_NetPathCanonicalize:PPROC
I_NetPathCanonicalize equ <__imp_I_NetPathCanonicalize>

externdef __imp_I_NetPathCompare:PPROC
I_NetPathCompare equ <__imp_I_NetPathCompare>

externdef __imp_I_NetPathType:PPROC
I_NetPathType equ <__imp_I_NetPathType>

externdef __imp_I_NetServerAuthenticate2:PPROC
I_NetServerAuthenticate2 equ <__imp_I_NetServerAuthenticate2>

externdef __imp_I_NetServerAuthenticate3:PPROC
I_NetServerAuthenticate3 equ <__imp_I_NetServerAuthenticate3>

externdef __imp_I_NetServerAuthenticate:PPROC
I_NetServerAuthenticate equ <__imp_I_NetServerAuthenticate>

externdef __imp_I_NetServerGetTrustInfo:PPROC
I_NetServerGetTrustInfo equ <__imp_I_NetServerGetTrustInfo>

externdef __imp_I_NetServerPasswordGet:PPROC
I_NetServerPasswordGet equ <__imp_I_NetServerPasswordGet>

externdef __imp_I_NetServerPasswordSet2:PPROC
I_NetServerPasswordSet2 equ <__imp_I_NetServerPasswordSet2>

externdef __imp_I_NetServerPasswordSet:PPROC
I_NetServerPasswordSet equ <__imp_I_NetServerPasswordSet>

externdef __imp_I_NetServerReqChallenge:PPROC
I_NetServerReqChallenge equ <__imp_I_NetServerReqChallenge>

externdef __imp_I_NetServerSetServiceBits:PPROC
I_NetServerSetServiceBits equ <__imp_I_NetServerSetServiceBits>

externdef __imp_I_NetServerSetServiceBitsEx:PPROC
I_NetServerSetServiceBitsEx equ <__imp_I_NetServerSetServiceBitsEx>

externdef __imp_I_NetServerTrustPasswordsGet:PPROC
I_NetServerTrustPasswordsGet equ <__imp_I_NetServerTrustPasswordsGet>

externdef __imp_I_NetlogonComputeClientDigest:PPROC
I_NetlogonComputeClientDigest equ <__imp_I_NetlogonComputeClientDigest>

externdef __imp_I_NetlogonComputeServerDigest:PPROC
I_NetlogonComputeServerDigest equ <__imp_I_NetlogonComputeServerDigest>

externdef __imp_I_NetlogonGetTrustRid:PPROC
I_NetlogonGetTrustRid equ <__imp_I_NetlogonGetTrustRid>

externdef __imp_NetAddAlternateComputerName:PPROC
NetAddAlternateComputerName equ <__imp_NetAddAlternateComputerName>

externdef __imp_NetAlertRaise:PPROC
NetAlertRaise equ <__imp_NetAlertRaise>

externdef __imp_NetAlertRaiseEx:PPROC
NetAlertRaiseEx equ <__imp_NetAlertRaiseEx>

externdef __imp_NetApiBufferAllocate:PPROC
NetApiBufferAllocate equ <__imp_NetApiBufferAllocate>

externdef __imp_NetApiBufferFree:PPROC
NetApiBufferFree equ <__imp_NetApiBufferFree>

externdef __imp_NetApiBufferReallocate:PPROC
NetApiBufferReallocate equ <__imp_NetApiBufferReallocate>

externdef __imp_NetApiBufferSize:PPROC
NetApiBufferSize equ <__imp_NetApiBufferSize>

externdef __imp_NetAuditClear:PPROC
NetAuditClear equ <__imp_NetAuditClear>

externdef __imp_NetAuditRead:PPROC
NetAuditRead equ <__imp_NetAuditRead>

externdef __imp_NetAuditWrite:PPROC
NetAuditWrite equ <__imp_NetAuditWrite>

externdef __imp_NetBrowserStatisticsGet:PPROC
NetBrowserStatisticsGet equ <__imp_NetBrowserStatisticsGet>

externdef __imp_NetConfigGet:PPROC
NetConfigGet equ <__imp_NetConfigGet>

externdef __imp_NetConfigGetAll:PPROC
NetConfigGetAll equ <__imp_NetConfigGetAll>

externdef __imp_NetConfigSet:PPROC
NetConfigSet equ <__imp_NetConfigSet>

externdef __imp_NetConnectionEnum:PPROC
NetConnectionEnum equ <__imp_NetConnectionEnum>

externdef __imp_NetDfsAdd:PPROC
NetDfsAdd equ <__imp_NetDfsAdd>

externdef __imp_NetDfsAddFtRoot:PPROC
NetDfsAddFtRoot equ <__imp_NetDfsAddFtRoot>

externdef __imp_NetDfsAddStdRoot:PPROC
NetDfsAddStdRoot equ <__imp_NetDfsAddStdRoot>

externdef __imp_NetDfsAddStdRootForced:PPROC
NetDfsAddStdRootForced equ <__imp_NetDfsAddStdRootForced>

externdef __imp_NetDfsEnum:PPROC
NetDfsEnum equ <__imp_NetDfsEnum>

externdef __imp_NetDfsGetClientInfo:PPROC
NetDfsGetClientInfo equ <__imp_NetDfsGetClientInfo>

externdef __imp_NetDfsGetDcAddress:PPROC
NetDfsGetDcAddress equ <__imp_NetDfsGetDcAddress>

externdef __imp_NetDfsGetFtContainerSecurity:PPROC
NetDfsGetFtContainerSecurity equ <__imp_NetDfsGetFtContainerSecurity>

externdef __imp_NetDfsGetInfo:PPROC
NetDfsGetInfo equ <__imp_NetDfsGetInfo>

externdef __imp_NetDfsGetSecurity:PPROC
NetDfsGetSecurity equ <__imp_NetDfsGetSecurity>

externdef __imp_NetDfsGetStdContainerSecurity:PPROC
NetDfsGetStdContainerSecurity equ <__imp_NetDfsGetStdContainerSecurity>

externdef __imp_NetDfsManagerGetConfigInfo:PPROC
NetDfsManagerGetConfigInfo equ <__imp_NetDfsManagerGetConfigInfo>

externdef __imp_NetDfsManagerInitialize:PPROC
NetDfsManagerInitialize equ <__imp_NetDfsManagerInitialize>

externdef __imp_NetDfsManagerSendSiteInfo:PPROC
NetDfsManagerSendSiteInfo equ <__imp_NetDfsManagerSendSiteInfo>

externdef __imp_NetDfsMove:PPROC
NetDfsMove equ <__imp_NetDfsMove>

externdef __imp_NetDfsRemove:PPROC
NetDfsRemove equ <__imp_NetDfsRemove>

externdef __imp_NetDfsRemoveFtRoot:PPROC
NetDfsRemoveFtRoot equ <__imp_NetDfsRemoveFtRoot>

externdef __imp_NetDfsRemoveFtRootForced:PPROC
NetDfsRemoveFtRootForced equ <__imp_NetDfsRemoveFtRootForced>

externdef __imp_NetDfsRemoveStdRoot:PPROC
NetDfsRemoveStdRoot equ <__imp_NetDfsRemoveStdRoot>

externdef __imp_NetDfsRename:PPROC
NetDfsRename equ <__imp_NetDfsRename>

externdef __imp_NetDfsSetClientInfo:PPROC
NetDfsSetClientInfo equ <__imp_NetDfsSetClientInfo>

externdef __imp_NetDfsSetFtContainerSecurity:PPROC
NetDfsSetFtContainerSecurity equ <__imp_NetDfsSetFtContainerSecurity>

externdef __imp_NetDfsSetInfo:PPROC
NetDfsSetInfo equ <__imp_NetDfsSetInfo>

externdef __imp_NetDfsSetSecurity:PPROC
NetDfsSetSecurity equ <__imp_NetDfsSetSecurity>

externdef __imp_NetDfsSetStdContainerSecurity:PPROC
NetDfsSetStdContainerSecurity equ <__imp_NetDfsSetStdContainerSecurity>

externdef __imp_NetEnumerateComputerNames:PPROC
NetEnumerateComputerNames equ <__imp_NetEnumerateComputerNames>

externdef __imp_NetEnumerateTrustedDomains:PPROC
NetEnumerateTrustedDomains equ <__imp_NetEnumerateTrustedDomains>

externdef __imp_NetErrorLogClear:PPROC
NetErrorLogClear equ <__imp_NetErrorLogClear>

externdef __imp_NetErrorLogRead:PPROC
NetErrorLogRead equ <__imp_NetErrorLogRead>

externdef __imp_NetErrorLogWrite:PPROC
NetErrorLogWrite equ <__imp_NetErrorLogWrite>

externdef __imp_NetFileClose:PPROC
NetFileClose equ <__imp_NetFileClose>

externdef __imp_NetFileEnum:PPROC
NetFileEnum equ <__imp_NetFileEnum>

externdef __imp_NetFileGetInfo:PPROC
NetFileGetInfo equ <__imp_NetFileGetInfo>

externdef __imp_NetGetAnyDCName:PPROC
NetGetAnyDCName equ <__imp_NetGetAnyDCName>

externdef __imp_NetGetDCName:PPROC
NetGetDCName equ <__imp_NetGetDCName>

externdef __imp_NetGetDisplayInformationIndex:PPROC
NetGetDisplayInformationIndex equ <__imp_NetGetDisplayInformationIndex>

externdef __imp_NetGetJoinInformation:PPROC
NetGetJoinInformation equ <__imp_NetGetJoinInformation>

externdef __imp_NetGetJoinableOUs:PPROC
NetGetJoinableOUs equ <__imp_NetGetJoinableOUs>

externdef __imp_NetGroupAdd:PPROC
NetGroupAdd equ <__imp_NetGroupAdd>

externdef __imp_NetGroupAddUser:PPROC
NetGroupAddUser equ <__imp_NetGroupAddUser>

externdef __imp_NetGroupDel:PPROC
NetGroupDel equ <__imp_NetGroupDel>

externdef __imp_NetGroupDelUser:PPROC
NetGroupDelUser equ <__imp_NetGroupDelUser>

externdef __imp_NetGroupEnum:PPROC
NetGroupEnum equ <__imp_NetGroupEnum>

externdef __imp_NetGroupGetInfo:PPROC
NetGroupGetInfo equ <__imp_NetGroupGetInfo>

externdef __imp_NetGroupGetUsers:PPROC
NetGroupGetUsers equ <__imp_NetGroupGetUsers>

externdef __imp_NetGroupSetInfo:PPROC
NetGroupSetInfo equ <__imp_NetGroupSetInfo>

externdef __imp_NetGroupSetUsers:PPROC
NetGroupSetUsers equ <__imp_NetGroupSetUsers>

externdef __imp_NetJoinDomain:PPROC
NetJoinDomain equ <__imp_NetJoinDomain>

externdef __imp_NetLocalGroupAdd:PPROC
NetLocalGroupAdd equ <__imp_NetLocalGroupAdd>

externdef __imp_NetLocalGroupAddMember:PPROC
NetLocalGroupAddMember equ <__imp_NetLocalGroupAddMember>

externdef __imp_NetLocalGroupAddMembers:PPROC
NetLocalGroupAddMembers equ <__imp_NetLocalGroupAddMembers>

externdef __imp_NetLocalGroupDel:PPROC
NetLocalGroupDel equ <__imp_NetLocalGroupDel>

externdef __imp_NetLocalGroupDelMember:PPROC
NetLocalGroupDelMember equ <__imp_NetLocalGroupDelMember>

externdef __imp_NetLocalGroupDelMembers:PPROC
NetLocalGroupDelMembers equ <__imp_NetLocalGroupDelMembers>

externdef __imp_NetLocalGroupEnum:PPROC
NetLocalGroupEnum equ <__imp_NetLocalGroupEnum>

externdef __imp_NetLocalGroupGetInfo:PPROC
NetLocalGroupGetInfo equ <__imp_NetLocalGroupGetInfo>

externdef __imp_NetLocalGroupGetMembers:PPROC
NetLocalGroupGetMembers equ <__imp_NetLocalGroupGetMembers>

externdef __imp_NetLocalGroupSetInfo:PPROC
NetLocalGroupSetInfo equ <__imp_NetLocalGroupSetInfo>

externdef __imp_NetLocalGroupSetMembers:PPROC
NetLocalGroupSetMembers equ <__imp_NetLocalGroupSetMembers>

externdef __imp_NetLogonGetTimeServiceParentDomain:PPROC
NetLogonGetTimeServiceParentDomain equ <__imp_NetLogonGetTimeServiceParentDomain>

externdef __imp_NetLogonSetServiceBits:PPROC
NetLogonSetServiceBits equ <__imp_NetLogonSetServiceBits>

externdef __imp_NetMessageBufferSend:PPROC
NetMessageBufferSend equ <__imp_NetMessageBufferSend>

externdef __imp_NetMessageNameAdd:PPROC
NetMessageNameAdd equ <__imp_NetMessageNameAdd>

externdef __imp_NetMessageNameDel:PPROC
NetMessageNameDel equ <__imp_NetMessageNameDel>

externdef __imp_NetMessageNameEnum:PPROC
NetMessageNameEnum equ <__imp_NetMessageNameEnum>

externdef __imp_NetMessageNameGetInfo:PPROC
NetMessageNameGetInfo equ <__imp_NetMessageNameGetInfo>

externdef __imp_NetQueryDisplayInformation:PPROC
NetQueryDisplayInformation equ <__imp_NetQueryDisplayInformation>

externdef __imp_NetRegisterDomainNameChangeNotification:PPROC
NetRegisterDomainNameChangeNotification equ <__imp_NetRegisterDomainNameChangeNotification>

externdef __imp_NetRemoteComputerSupports:PPROC
NetRemoteComputerSupports equ <__imp_NetRemoteComputerSupports>

externdef __imp_NetRemoteTOD:PPROC
NetRemoteTOD equ <__imp_NetRemoteTOD>

externdef __imp_NetRemoveAlternateComputerName:PPROC
NetRemoveAlternateComputerName equ <__imp_NetRemoveAlternateComputerName>

externdef __imp_NetRenameMachineInDomain:PPROC
NetRenameMachineInDomain equ <__imp_NetRenameMachineInDomain>

externdef __imp_NetReplExportDirAdd:PPROC
NetReplExportDirAdd equ <__imp_NetReplExportDirAdd>

externdef __imp_NetReplExportDirDel:PPROC
NetReplExportDirDel equ <__imp_NetReplExportDirDel>

externdef __imp_NetReplExportDirEnum:PPROC
NetReplExportDirEnum equ <__imp_NetReplExportDirEnum>

externdef __imp_NetReplExportDirGetInfo:PPROC
NetReplExportDirGetInfo equ <__imp_NetReplExportDirGetInfo>

externdef __imp_NetReplExportDirLock:PPROC
NetReplExportDirLock equ <__imp_NetReplExportDirLock>

externdef __imp_NetReplExportDirSetInfo:PPROC
NetReplExportDirSetInfo equ <__imp_NetReplExportDirSetInfo>

externdef __imp_NetReplExportDirUnlock:PPROC
NetReplExportDirUnlock equ <__imp_NetReplExportDirUnlock>

externdef __imp_NetReplGetInfo:PPROC
NetReplGetInfo equ <__imp_NetReplGetInfo>

externdef __imp_NetReplImportDirAdd:PPROC
NetReplImportDirAdd equ <__imp_NetReplImportDirAdd>

externdef __imp_NetReplImportDirDel:PPROC
NetReplImportDirDel equ <__imp_NetReplImportDirDel>

externdef __imp_NetReplImportDirEnum:PPROC
NetReplImportDirEnum equ <__imp_NetReplImportDirEnum>

externdef __imp_NetReplImportDirGetInfo:PPROC
NetReplImportDirGetInfo equ <__imp_NetReplImportDirGetInfo>

externdef __imp_NetReplImportDirLock:PPROC
NetReplImportDirLock equ <__imp_NetReplImportDirLock>

externdef __imp_NetReplImportDirUnlock:PPROC
NetReplImportDirUnlock equ <__imp_NetReplImportDirUnlock>

externdef __imp_NetReplSetInfo:PPROC
NetReplSetInfo equ <__imp_NetReplSetInfo>

externdef __imp_NetScheduleJobAdd:PPROC
NetScheduleJobAdd equ <__imp_NetScheduleJobAdd>

externdef __imp_NetScheduleJobDel:PPROC
NetScheduleJobDel equ <__imp_NetScheduleJobDel>

externdef __imp_NetScheduleJobEnum:PPROC
NetScheduleJobEnum equ <__imp_NetScheduleJobEnum>

externdef __imp_NetScheduleJobGetInfo:PPROC
NetScheduleJobGetInfo equ <__imp_NetScheduleJobGetInfo>

externdef __imp_NetServerComputerNameAdd:PPROC
NetServerComputerNameAdd equ <__imp_NetServerComputerNameAdd>

externdef __imp_NetServerComputerNameDel:PPROC
NetServerComputerNameDel equ <__imp_NetServerComputerNameDel>

externdef __imp_NetServerDiskEnum:PPROC
NetServerDiskEnum equ <__imp_NetServerDiskEnum>

externdef __imp_NetServerEnum:PPROC
NetServerEnum equ <__imp_NetServerEnum>

externdef __imp_NetServerEnumEx:PPROC
NetServerEnumEx equ <__imp_NetServerEnumEx>

externdef __imp_NetServerGetInfo:PPROC
NetServerGetInfo equ <__imp_NetServerGetInfo>

externdef __imp_NetServerSetInfo:PPROC
NetServerSetInfo equ <__imp_NetServerSetInfo>

externdef __imp_NetServerTransportAdd:PPROC
NetServerTransportAdd equ <__imp_NetServerTransportAdd>

externdef __imp_NetServerTransportAddEx:PPROC
NetServerTransportAddEx equ <__imp_NetServerTransportAddEx>

externdef __imp_NetServerTransportDel:PPROC
NetServerTransportDel equ <__imp_NetServerTransportDel>

externdef __imp_NetServerTransportEnum:PPROC
NetServerTransportEnum equ <__imp_NetServerTransportEnum>

externdef __imp_NetServiceControl:PPROC
NetServiceControl equ <__imp_NetServiceControl>

externdef __imp_NetServiceEnum:PPROC
NetServiceEnum equ <__imp_NetServiceEnum>

externdef __imp_NetServiceGetInfo:PPROC
NetServiceGetInfo equ <__imp_NetServiceGetInfo>

externdef __imp_NetServiceInstall:PPROC
NetServiceInstall equ <__imp_NetServiceInstall>

externdef __imp_NetSessionDel:PPROC
NetSessionDel equ <__imp_NetSessionDel>

externdef __imp_NetSessionEnum:PPROC
NetSessionEnum equ <__imp_NetSessionEnum>

externdef __imp_NetSessionGetInfo:PPROC
NetSessionGetInfo equ <__imp_NetSessionGetInfo>

externdef __imp_NetSetPrimaryComputerName:PPROC
NetSetPrimaryComputerName equ <__imp_NetSetPrimaryComputerName>

externdef __imp_NetShareAdd:PPROC
NetShareAdd equ <__imp_NetShareAdd>

externdef __imp_NetShareCheck:PPROC
NetShareCheck equ <__imp_NetShareCheck>

externdef __imp_NetShareDel:PPROC
NetShareDel equ <__imp_NetShareDel>

externdef __imp_NetShareDelSticky:PPROC
NetShareDelSticky equ <__imp_NetShareDelSticky>

externdef __imp_NetShareEnum:PPROC
NetShareEnum equ <__imp_NetShareEnum>

externdef __imp_NetShareEnumSticky:PPROC
NetShareEnumSticky equ <__imp_NetShareEnumSticky>

externdef __imp_NetShareGetInfo:PPROC
NetShareGetInfo equ <__imp_NetShareGetInfo>

externdef __imp_NetShareSetInfo:PPROC
NetShareSetInfo equ <__imp_NetShareSetInfo>

externdef __imp_NetStatisticsGet:PPROC
NetStatisticsGet equ <__imp_NetStatisticsGet>

externdef __imp_NetUnjoinDomain:PPROC
NetUnjoinDomain equ <__imp_NetUnjoinDomain>

externdef __imp_NetUnregisterDomainNameChangeNotification:PPROC
NetUnregisterDomainNameChangeNotification equ <__imp_NetUnregisterDomainNameChangeNotification>

externdef __imp_NetUseAdd:PPROC
NetUseAdd equ <__imp_NetUseAdd>

externdef __imp_NetUseDel:PPROC
NetUseDel equ <__imp_NetUseDel>

externdef __imp_NetUseEnum:PPROC
NetUseEnum equ <__imp_NetUseEnum>

externdef __imp_NetUseGetInfo:PPROC
NetUseGetInfo equ <__imp_NetUseGetInfo>

externdef __imp_NetUserAdd:PPROC
NetUserAdd equ <__imp_NetUserAdd>

externdef __imp_NetUserChangePassword:PPROC
NetUserChangePassword equ <__imp_NetUserChangePassword>

externdef __imp_NetUserDel:PPROC
NetUserDel equ <__imp_NetUserDel>

externdef __imp_NetUserEnum:PPROC
NetUserEnum equ <__imp_NetUserEnum>

externdef __imp_NetUserGetGroups:PPROC
NetUserGetGroups equ <__imp_NetUserGetGroups>

externdef __imp_NetUserGetInfo:PPROC
NetUserGetInfo equ <__imp_NetUserGetInfo>

externdef __imp_NetUserGetLocalGroups:PPROC
NetUserGetLocalGroups equ <__imp_NetUserGetLocalGroups>

externdef __imp_NetUserModalsGet:PPROC
NetUserModalsGet equ <__imp_NetUserModalsGet>

externdef __imp_NetUserModalsSet:PPROC
NetUserModalsSet equ <__imp_NetUserModalsSet>

externdef __imp_NetUserSetGroups:PPROC
NetUserSetGroups equ <__imp_NetUserSetGroups>

externdef __imp_NetUserSetInfo:PPROC
NetUserSetInfo equ <__imp_NetUserSetInfo>

externdef __imp_NetValidateName:PPROC
NetValidateName equ <__imp_NetValidateName>

externdef __imp_NetValidatePasswordPolicy:PPROC
NetValidatePasswordPolicy equ <__imp_NetValidatePasswordPolicy>

externdef __imp_NetValidatePasswordPolicyFree:PPROC
NetValidatePasswordPolicyFree equ <__imp_NetValidatePasswordPolicyFree>

externdef __imp_NetWkstaGetInfo:PPROC
NetWkstaGetInfo equ <__imp_NetWkstaGetInfo>

externdef __imp_NetWkstaSetInfo:PPROC
NetWkstaSetInfo equ <__imp_NetWkstaSetInfo>

externdef __imp_NetWkstaTransportAdd:PPROC
NetWkstaTransportAdd equ <__imp_NetWkstaTransportAdd>

externdef __imp_NetWkstaTransportDel:PPROC
NetWkstaTransportDel equ <__imp_NetWkstaTransportDel>

externdef __imp_NetWkstaTransportEnum:PPROC
NetWkstaTransportEnum equ <__imp_NetWkstaTransportEnum>

externdef __imp_NetWkstaUserEnum:PPROC
NetWkstaUserEnum equ <__imp_NetWkstaUserEnum>

externdef __imp_NetWkstaUserGetInfo:PPROC
NetWkstaUserGetInfo equ <__imp_NetWkstaUserGetInfo>

externdef __imp_NetWkstaUserSetInfo:PPROC
NetWkstaUserSetInfo equ <__imp_NetWkstaUserSetInfo>

externdef __imp_NetapipBufferAllocate:PPROC
NetapipBufferAllocate equ <__imp_NetapipBufferAllocate>

externdef __imp_Netbios:PPROC
Netbios equ <__imp_Netbios>

externdef __imp_NetpAccessCheck:PPROC
NetpAccessCheck equ <__imp_NetpAccessCheck>

externdef __imp_NetpAccessCheckAndAudit:PPROC
NetpAccessCheckAndAudit equ <__imp_NetpAccessCheckAndAudit>

externdef __imp_NetpAddTlnFtinfoEntry:PPROC
NetpAddTlnFtinfoEntry equ <__imp_NetpAddTlnFtinfoEntry>

externdef __imp_NetpAllocConfigName:PPROC
NetpAllocConfigName equ <__imp_NetpAllocConfigName>

externdef __imp_NetpAllocFtinfoEntry:PPROC
NetpAllocFtinfoEntry equ <__imp_NetpAllocFtinfoEntry>

externdef __imp_NetpAllocStrFromWStr:PPROC
NetpAllocStrFromWStr equ <__imp_NetpAllocStrFromWStr>

externdef __imp_NetpAllocWStrFromStr:PPROC
NetpAllocWStrFromStr equ <__imp_NetpAllocWStrFromStr>

externdef __imp_NetpAllocWStrFromWStr:PPROC
NetpAllocWStrFromWStr equ <__imp_NetpAllocWStrFromWStr>

externdef __imp_NetpApiStatusToNtStatus:PPROC
NetpApiStatusToNtStatus equ <__imp_NetpApiStatusToNtStatus>

externdef __imp_NetpAssertFailed:PPROC
NetpAssertFailed equ <__imp_NetpAssertFailed>

externdef __imp_NetpCleanFtinfoContext:PPROC
NetpCleanFtinfoContext equ <__imp_NetpCleanFtinfoContext>

externdef __imp_NetpCloseConfigData:PPROC
NetpCloseConfigData equ <__imp_NetpCloseConfigData>

externdef __imp_NetpCopyFtinfoContext:PPROC
NetpCopyFtinfoContext equ <__imp_NetpCopyFtinfoContext>

externdef __imp_NetpCopyStringToBuffer:PPROC
NetpCopyStringToBuffer equ <__imp_NetpCopyStringToBuffer>

externdef __imp_NetpCreateSecurityObject:PPROC
NetpCreateSecurityObject equ <__imp_NetpCreateSecurityObject>

externdef __imp_NetpDbgPrint:PPROC
NetpDbgPrint equ <__imp_NetpDbgPrint>

externdef __imp_NetpDeleteSecurityObject:PPROC
NetpDeleteSecurityObject equ <__imp_NetpDeleteSecurityObject>

externdef __imp_NetpGetComputerName:PPROC
NetpGetComputerName equ <__imp_NetpGetComputerName>

externdef __imp_NetpGetConfigBool:PPROC
NetpGetConfigBool equ <__imp_NetpGetConfigBool>

externdef __imp_NetpGetConfigDword:PPROC
NetpGetConfigDword equ <__imp_NetpGetConfigDword>

externdef __imp_NetpGetConfigTStrArray:PPROC
NetpGetConfigTStrArray equ <__imp_NetpGetConfigTStrArray>

externdef __imp_NetpGetConfigValue:PPROC
NetpGetConfigValue equ <__imp_NetpGetConfigValue>

externdef __imp_NetpGetDomainName:PPROC
NetpGetDomainName equ <__imp_NetpGetDomainName>

externdef __imp_NetpGetFileSecurity:PPROC
NetpGetFileSecurity equ <__imp_NetpGetFileSecurity>

externdef __imp_NetpGetPrivilege:PPROC
NetpGetPrivilege equ <__imp_NetpGetPrivilege>

externdef __imp_NetpHexDump:PPROC
NetpHexDump equ <__imp_NetpHexDump>

externdef __imp_NetpInitFtinfoContext:PPROC
NetpInitFtinfoContext equ <__imp_NetpInitFtinfoContext>

externdef __imp_NetpInitOemString:PPROC
NetpInitOemString equ <__imp_NetpInitOemString>

externdef __imp_NetpIsRemote:PPROC
NetpIsRemote equ <__imp_NetpIsRemote>

externdef __imp_NetpIsUncComputerNameValid:PPROC
NetpIsUncComputerNameValid equ <__imp_NetpIsUncComputerNameValid>

externdef __imp_NetpLocalTimeZoneOffset:PPROC
NetpLocalTimeZoneOffset equ <__imp_NetpLocalTimeZoneOffset>

externdef __imp_NetpLogonPutUnicodeString:PPROC
NetpLogonPutUnicodeString equ <__imp_NetpLogonPutUnicodeString>

externdef __imp_NetpMergeFtinfo:PPROC
NetpMergeFtinfo equ <__imp_NetpMergeFtinfo>

externdef __imp_NetpNetBiosAddName:PPROC
NetpNetBiosAddName equ <__imp_NetpNetBiosAddName>

externdef __imp_NetpNetBiosCall:PPROC
NetpNetBiosCall equ <__imp_NetpNetBiosCall>

externdef __imp_NetpNetBiosDelName:PPROC
NetpNetBiosDelName equ <__imp_NetpNetBiosDelName>

externdef __imp_NetpNetBiosGetAdapterNumbers:PPROC
NetpNetBiosGetAdapterNumbers equ <__imp_NetpNetBiosGetAdapterNumbers>

externdef __imp_NetpNetBiosHangup:PPROC
NetpNetBiosHangup equ <__imp_NetpNetBiosHangup>

externdef __imp_NetpNetBiosReceive:PPROC
NetpNetBiosReceive equ <__imp_NetpNetBiosReceive>

externdef __imp_NetpNetBiosReset:PPROC
NetpNetBiosReset equ <__imp_NetpNetBiosReset>

externdef __imp_NetpNetBiosSend:PPROC
NetpNetBiosSend equ <__imp_NetpNetBiosSend>

externdef __imp_NetpNetBiosStatusToApiStatus:PPROC
NetpNetBiosStatusToApiStatus equ <__imp_NetpNetBiosStatusToApiStatus>

externdef __imp_NetpNtStatusToApiStatus:PPROC
NetpNtStatusToApiStatus equ <__imp_NetpNtStatusToApiStatus>

externdef __imp_NetpOpenConfigData:PPROC
NetpOpenConfigData equ <__imp_NetpOpenConfigData>

externdef __imp_NetpPackString:PPROC
NetpPackString equ <__imp_NetpPackString>

externdef __imp_NetpParmsQueryUserProperty:PPROC
NetpParmsQueryUserProperty equ <__imp_NetpParmsQueryUserProperty>

externdef __imp_NetpParmsQueryUserPropertyWithLength:PPROC
NetpParmsQueryUserPropertyWithLength equ <__imp_NetpParmsQueryUserPropertyWithLength>

externdef __imp_NetpParmsSetUserProperty:PPROC
NetpParmsSetUserProperty equ <__imp_NetpParmsSetUserProperty>

externdef __imp_NetpParmsSetUserPropertyWithLength:PPROC
NetpParmsSetUserPropertyWithLength equ <__imp_NetpParmsSetUserPropertyWithLength>

externdef __imp_NetpParmsUserPropertyFree:PPROC
NetpParmsUserPropertyFree equ <__imp_NetpParmsUserPropertyFree>

externdef __imp_NetpReleasePrivilege:PPROC
NetpReleasePrivilege equ <__imp_NetpReleasePrivilege>

externdef __imp_NetpSetFileSecurity:PPROC
NetpSetFileSecurity equ <__imp_NetpSetFileSecurity>

externdef __imp_NetpSmbCheck:PPROC
NetpSmbCheck equ <__imp_NetpSmbCheck>

externdef __imp_NetpStoreIntialDcRecord:PPROC
NetpStoreIntialDcRecord equ <__imp_NetpStoreIntialDcRecord>

externdef __imp_NetpStringToNetBiosName:PPROC
NetpStringToNetBiosName equ <__imp_NetpStringToNetBiosName>

externdef __imp_NetpTStrArrayEntryCount:PPROC
NetpTStrArrayEntryCount equ <__imp_NetpTStrArrayEntryCount>

externdef __imp_NetpUpgradePreNT5JoinInfo:PPROC
NetpUpgradePreNT5JoinInfo equ <__imp_NetpUpgradePreNT5JoinInfo>

externdef __imp_NetpwNameCanonicalize:PPROC
NetpwNameCanonicalize equ <__imp_NetpwNameCanonicalize>

externdef __imp_NetpwNameCompare:PPROC
NetpwNameCompare equ <__imp_NetpwNameCompare>

externdef __imp_NetpwNameValidate:PPROC
NetpwNameValidate equ <__imp_NetpwNameValidate>

externdef __imp_NetpwPathCanonicalize:PPROC
NetpwPathCanonicalize equ <__imp_NetpwPathCanonicalize>

externdef __imp_NetpwPathCompare:PPROC
NetpwPathCompare equ <__imp_NetpwPathCompare>

externdef __imp_NetpwPathType:PPROC
NetpwPathType equ <__imp_NetpwPathType>

externdef __imp_NlBindingAddServerToCache:PPROC
NlBindingAddServerToCache equ <__imp_NlBindingAddServerToCache>

externdef __imp_NlBindingRemoveServerFromCache:PPROC
NlBindingRemoveServerFromCache equ <__imp_NlBindingRemoveServerFromCache>

externdef __imp_NlBindingSetAuthInfo:PPROC
NlBindingSetAuthInfo equ <__imp_NlBindingSetAuthInfo>

externdef __imp_RxNetAccessAdd:PPROC
RxNetAccessAdd equ <__imp_RxNetAccessAdd>

externdef __imp_RxNetAccessDel:PPROC
RxNetAccessDel equ <__imp_RxNetAccessDel>

externdef __imp_RxNetAccessEnum:PPROC
RxNetAccessEnum equ <__imp_RxNetAccessEnum>

externdef __imp_RxNetAccessGetInfo:PPROC
RxNetAccessGetInfo equ <__imp_RxNetAccessGetInfo>

externdef __imp_RxNetAccessGetUserPerms:PPROC
RxNetAccessGetUserPerms equ <__imp_RxNetAccessGetUserPerms>

externdef __imp_RxNetAccessSetInfo:PPROC
RxNetAccessSetInfo equ <__imp_RxNetAccessSetInfo>

externdef __imp_RxNetServerEnum:PPROC
RxNetServerEnum equ <__imp_RxNetServerEnum>

externdef __imp_RxNetUserPasswordSet:PPROC
RxNetUserPasswordSet equ <__imp_RxNetUserPasswordSet>

externdef __imp_RxRemoteApi:PPROC
RxRemoteApi equ <__imp_RxRemoteApi>
