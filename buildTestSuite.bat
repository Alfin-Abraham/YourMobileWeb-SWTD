@echo off
:: Set recipient, sender email, and app password
SET recipient_email=%1
SET sender_email=nallakarthik728@gmail.com
SET app_password=ajbshimmmjqxxvyv
 
:: Navigate to the script's directory
cd %~dp0
 
:: Build the software solution
:: Path to MSBuild and solution file specified
:: Checks for build error status
"C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\amd64\MSBuild.exe" "C:\Users\nkart\source\repos\YourMobileWeb-SWTD\YourMobileGuide.sln" /t:Build /p:Configuration=Release
IF %ERRORLEVEL% NEQ 0 (
    SET build_status=False
) ELSE (
    SET build_status=True
)
 
:: Initialize test status variables
SET unit_test_status=False
SET ui_test_status=False
 
:: Execute unit tests and update status
"C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\CommonExtensions\Microsoft\TestWindow\vstest.console.exe" "C:\Users\nkart\source\repos\YourMobileWeb-SWTD\UnitTests\bin\Release\net6.0\UnitTests.dll"
IF %ERRORLEVEL% NEQ 0 (
    SET unit_test_status=False
) ELSE (
    SET unit_test_status=True
)
 
:: Execute UI tests and update status
"C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\CommonExtensions\Microsoft\TestWindow\vstest.console.exe" "C:\Users\nkart\source\repos\YourMobileWeb-SWTD\UITest\bin\Release\net6.0\UITest.dll"
IF %ERRORLEVEL% NEQ 0 (
    SET ui_test_status=False
) ELSE (
    SET ui_test_status=True
)
 
:SendEmail
:: Sending email using PowerShell
:: Builds the email body with build and test statuses
:: Uses System.Net.Mail for SMTP email sending
powershell -ExecutionPolicy Bypass -Command "& { param([string]$buildStatus, [string]$unitTestStatus, [string]$uiTestStatus, [string]$senderEmail, [string]$appPassword) $body = 'Did Build Succeed: ' + $buildStatus + [Environment]::NewLine + 'Did Unit Tests Pass: ' + $unitTestStatus + [Environment]::NewLine + 'Did UI Tests Pass: ' + $uiTestStatus; $mail = New-Object System.Net.Mail.MailMessage; $smtp = New-Object System.Net.Mail.SmtpClient('smtp.gmail.com', 587); $smtp.EnableSsl = $true; $smtp.Credentials = New-Object System.Net.NetworkCredential($senderEmail, $appPassword); $mail.From = $senderEmail; $mail.To.Add('%recipient_email%'); $mail.Subject = 'Build and Test Status'; $mail.Body = $body; $smtp.Send($mail); }" %build_status% %unit_test_status% %ui_test_status% %sender_email% %app_password%
 
:: End of script
