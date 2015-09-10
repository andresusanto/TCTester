VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "TC Tester"
   ClientHeight    =   4455
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8865
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4455
   ScaleWidth      =   8865
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox Text1 
      BackColor       =   &H8000000B&
      BeginProperty Font 
         Name            =   "Lucida Console"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   4215
      Left            =   5280
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   6
      Text            =   "Form1.frx":1042
      Top             =   120
      Width           =   3495
   End
   Begin VB.TextBox txtResult 
      BeginProperty Font 
         Name            =   "Lucida Console"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   3375
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   4
      Top             =   960
      Width           =   5055
   End
   Begin VB.FileListBox fdir 
      Height          =   285
      Left            =   8400
      TabIndex        =   3
      Top             =   6300
      Visible         =   0   'False
      Width           =   135
   End
   Begin VB.CommandButton cmdBrowse 
      Caption         =   "Browse"
      Height          =   375
      Left            =   3960
      TabIndex        =   2
      Top             =   120
      Width           =   1215
   End
   Begin VB.TextBox txtPath 
      Height          =   405
      Left            =   1200
      Locked          =   -1  'True
      TabIndex        =   0
      Top             =   120
      Width           =   2655
   End
   Begin MSComDlg.CommonDialog cd 
      Left            =   8640
      Top             =   6240
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      CancelError     =   -1  'True
   End
   Begin VB.Label Label2 
      Caption         =   "Hasil pengecekan:"
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   720
      Width           =   1575
   End
   Begin VB.Label Label1 
      Caption         =   "Path aplikasi"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   975
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
 
Private Type STARTUPINFO
 cb As Long
 lpReserved As String
 lpDesktop As String
 lpTitle As String
 dwX As Long
 dwY As Long
 dwXSize As Long
 dwYSize As Long
 dwXCountChars As Long
 dwYCountChars As Long
 dwFillAttribute As Long
 dwFlags As Long
 wShowWindow As Integer
 cbReserved2 As Integer
 lpReserved2 As Long
 hStdInput As Long
 hStdOutput As Long
 hStdError As Long
End Type
 
Private Type PROCESS_INFORMATION
 hProcess As Long
 hThread As Long
 dwProcessID As Long
 dwThreadID As Long
End Type
 
Private Declare Function WaitForSingleObject Lib "kernel32" (ByVal _
 hHandle As Long, ByVal dwMilliseconds As Long) As Long
 
Private Declare Function CreateProcessA Lib "kernel32" (ByVal _
 lpApplicationName As Long, ByVal lpCommandLine As String, ByVal _
 lpProcessAttributes As Long, ByVal lpThreadAttributes As Long, _
 ByVal bInheritHandles As Long, ByVal dwCreationFlags As Long, _
 ByVal lpEnvironment As Long, ByVal lpCurrentDirectory As Long, _
 lpStartupInfo As STARTUPINFO, lpProcessInformation As _
 PROCESS_INFORMATION) As Long
 
Private Declare Function CloseHandle Lib "kernel32" (ByVal _
 hObject As Long) As Long
 
Private Const NORMAL_PRIORITY_CLASS = &H20&
Private Const INFINITE = -1&


Private Sub cmdBrowse_Click()
    On Error GoTo cance1
    
    Dim LokasiF As String
    Dim i As Integer
    Dim sFileText As String
    Dim sFinal As String
    Dim iFileNo As Integer
    
    cd.DialogTitle = "Buka Aplikasi"
    cd.Filter = "EXE File (*.exe) | *.exe"
    cd.ShowOpen
    
    txtPath.Text = cd.FileName
    LokasiF = Replace(cd.FileName, cd.FileTitle, "")
    fdir.Path = LokasiF
    
    txtResult.Text = txtResult.Text & "--------------------------------------------" & vbCrLf
    txtResult.Text = txtResult.Text & "TC Tester by ASUS.JK " & vbCrLf
    txtResult.Text = txtResult.Text & "EXE NAME : " & cd.FileTitle & vbCrLf
    txtResult.Text = txtResult.Text & "--------------------------------------------" & vbCrLf
    
    
    For i = 0 To fdir.ListCount
        sFinal = ""
        
        If (Right$(fdir.List(i), 3) = ".in") Then
            ExecCmd "cmd.exe /k " & Chr(34) & cd.FileName & Chr(34) & " < " & fdir.List(i) & " >  " & fdir.List(i) & ".cek & exit"
            ExecCmd "cmd.exe /k fc.exe " & Chr(34) & LokasiF & fdir.List(i) & ".cek" & Chr(34) & " " & Chr(34) & LokasiF & Left$(fdir.List(i), Len(fdir.List(i)) - 3) & ".out" & Chr(34) & " > " & Chr(34) & LokasiF & fdir.List(i) & ".compare" & Chr(34) & " & exit"
            
            iFileNo = FreeFile
            Open LokasiF & fdir.List(i) & ".compare" For Input As #iFileNo
            Do While Not EOF(iFileNo)
                Input #iFileNo, sFileText
                sFinal = sFinal & sFileText & vbCrLf
            Loop
            Close #iFileNo
            
            If InStr(sFinal, "no differences encountered") Then
                txtResult.Text = txtResult.Text & fdir.List(i) & " -> " & fdir.List(i) & ".cek    (SUKSES - Sama)" & vbCrLf
            Else
                txtResult.Text = txtResult.Text & fdir.List(i) & " -> " & fdir.List(i) & ".cek    (GAGAL - Tidak Sama)" & vbCrLf
            End If
        End If
    Next
    txtResult.Text = txtResult.Text & "--------------------------------------------" & vbCrLf
cance1:
End Sub


Public Sub ExecCmd(cmdline As String)
    Dim proc As PROCESS_INFORMATION
    Dim start As STARTUPINFO
    Dim ReturnValue As Integer
    
    
    start.wShowWindow = 11
    start.cb = Len(start)
    
    ReturnValue = CreateProcessA(0&, cmdline$, 0&, 0&, 1&, _
    NORMAL_PRIORITY_CLASS, 0&, 0&, start, proc)
    
    Do
        ReturnValue = WaitForSingleObject(proc.hProcess, 0)
        DoEvents
    Loop Until ReturnValue <> 258
    
    ReturnValue = CloseHandle(proc.hProcess)
End Sub

