$ListeningPostIP = Read-Host "Please enter the IP of your Listening Post"

$subscriptions =@{
    "UserCreation" = "AS_GenericHTTP";
    "LoggedOnUserCreation"="AS_GenericHTTP";
    "ProcessCreation"="AS_GenericHTTP";
    "ProcessStartTrace"="AS_GenericHTTP";
    "ServerConnectionCreation"="AS_GenericHTTP";
    "ServiceCreation"="AS_GenericHTTP";
}

