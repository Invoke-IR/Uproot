$filters = @(
    "UserCreation",
    "LoggedOnUserCreation",
    "ProcessCreation",
    "ProcessStartTrace",
    "ServerConnectionCreation",
    "ServiceCreation"
)

$consumers = @(
    "AS_IntrinsicHTTP",
    "AS_ExtrinsicHTTP"
)

$subscriptions =@{
    "UserCreation" = "AS_IntrinsicHTTP";
    "LoggedOnUserCreation"="AS_IntrinsicHTTP";
    "ProcessCreation"="AS_IntrinsicHTTP";
    "ProcessStartTrace"="AS_ExtrinsicHTTP";
    "ServerConnectionCreation"="AS_IntrinsicHTTP";
    "ServiceCreation"="AS_IntrinsicHTTP";
}

