Sub SendEmailWithFormattedTableAndColors()
    Dim OutlookApp As Object
    Dim OutlookMail As Object
    Dim MailTo As String
    Dim MailSubject As String
    Dim MailBody As String
    Dim Cell As Range
    Dim DataRange As Range
    Dim i As Integer, j As Integer
    Dim Style As String
    
    ' Set the recipient, subject, and initial body of the email
    MailTo = "recipient@example.com"
    MailSubject = "Your Subject"
    MailBody = "<html><body><p>Hello, here is the data from the specified range:</p><br><table border='1' cellpadding='5' cellspacing='0'>"
    
    ' Specify the range you want to include in the email body
    Set DataRange = ThisWorkbook.Sheets("Sheet1").Range("A1:B3")
    
    ' Loop through each row in the range and add the data to the email body
    For i = 1 To DataRange.Rows.Count
        MailBody = MailBody & "<tr>"
        For j = 1 To DataRange.Columns.Count
            ' Get cell style and format
            Style = "style='"
            If DataRange.Cells(i, j).Interior.Color <> xlNone Then
                Style = Style & "background-color:rgb(" & _
                CLng(DataRange.Cells(i, j).Interior.Color Mod 256) & "," & _
                CLng((DataRange.Cells(i, j).Interior.Color \ 256) Mod 256) & "," & _
                CLng(DataRange.Cells(i, j).Interior.Color \ 65536) & ");"
            End If
            If DataRange.Cells(i, j).Font.Color <> xlNone Then
                Style = Style & "color:rgb(" & _
                CLng(DataRange.Cells(i, j).Font.Color Mod 256) & "," & _
                CLng((DataRange.Cells(i, j).Font.Color \ 256) Mod 256) & "," & _
                CLng(DataRange.Cells(i, j).Font.Color \ 65536) & ");"
            End If
            If DataRange.Cells(i, j).Font.Bold Then Style = Style & "font-weight:bold;"
            If DataRange.Cells(i, j).Font.Italic Then Style = Style & "font-style:italic;"
            If DataRange.Cells(i, j).Font.Underline Then Style = Style & "text-decoration:underline;"
            Style = Style & "'"
            ' Add cell value to the table
            MailBody = MailBody & "<td " & Style & ">" & DataRange.Cells(i, j).Value & "</td>"
        Next j
        MailBody = MailBody & "</tr>"
    Next i
    
    ' Close the table and HTML tags
    MailBody = MailBody & "</table></body></html>"
    
    ' Create Outlook application object
    Set OutlookApp = CreateObject("Outlook.Application")
    
    ' Create new email
    Set OutlookMail = OutlookApp.CreateItem(0)
    
    ' Set the properties of the email
    With OutlookMail
        .To = MailTo
        .Subject = MailSubject
        .HTMLBody = MailBody
        .Send
    End With
    
    ' Clean up
    Set OutlookMail = Nothing
    Set OutlookApp = Nothing
    
    MsgBox "Email with formatted and colored table has been sent successfully!", vbInformation
End Sub