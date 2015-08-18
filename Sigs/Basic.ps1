$filters = @(
    "UserCreation",
    "LoggedOnUserCreation",
    "ProcessCreation",
    "ProcessStartTrace",
    "ServerConnectionCreation",
    "ServiceCreation"
)

$consumers = @(
    "AS_IntrinsicHTTPPost",
    "AS_ExtrinsicHTTPPost"
)

$subscriptions =@{
    "UserCreation" = "AS_IntrinsicHTTPPost";
    "LoggedOnUserCreation"="AS_IntrinsicHTTPPost";
    "ProcessCreation"="AS_IntrinsicHTTPPost";
    "ProcessStartTrace"="AS_ExtrinsicHTTPPost";
    "ServerConnectionCreation"="AS_IntrinsicHTTPPost";
    "ServiceCreation"="AS_IntrinsicHTTPPost";
}

