VERSION 5.00
Object = "{307C5043-76B3-11CE-BF00-0080AD0EF894}#1.0#0"; "MSGHOO32.OCX"
Begin VB.Form Main 
   Caption         =   "Movable Blending Forms!"
   ClientHeight    =   3000
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4500
   ClipControls    =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   NegotiateMenus  =   0   'False
   Picture         =   "cthru01.frx":0000
   ScaleHeight     =   200
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   300
   StartUpPosition =   2  'CenterScreen
   Begin MsghookLib.Msghook mhkTrap 
      Left            =   120
      Top             =   120
      _Version        =   65536
      _ExtentX        =   847
      _ExtentY        =   847
      _StockProps     =   0
   End
   Begin VB.PictureBox picDC 
      AutoRedraw      =   -1  'True
      Height          =   0
      Left            =   0
      ScaleHeight     =   0
      ScaleWidth      =   0
      TabIndex        =   0
      Top             =   0
      Visible         =   0   'False
      Width           =   0
   End
End
Attribute VB_Name = "Main"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private cthru As Integer
Private Sub Form_Load()
cthru = 100
'Initialize the message hook control
mhkTrap.HwndHook = Me.hwnd
mhkTrap.Message(WM_MOVE) = True
'Set the size of the picture box the same as the form
With picDC
 .Width = Me.ScaleWidth + 10
 .Height = Me.ScaleHeight + 10
 .Left = 0
 .Top = 0
End With
End Sub

Private Sub Form_Paint()
DoEvents
'Hide the form
SetWindowPos Me.hwnd, -2, Me.Left / Screen.TwipsPerPixelX, Me.Top / Screen.TwipsPerPixelY, 300, 200, SWP_HIDEWINDOW
DoEvents
'Grab the background image
DeskHdc = GetDC(0)

'[***** Use This Section With Borders *****]
GetClientRect Me.hwnd, Inner
GetWindowRect Me.hwnd, Outer
DoEvents
ret = BitBlt(picDC.hdc, 0, 0, Me.ScaleWidth, Me.ScaleHeight, DeskHdc, (Me.Left / Screen.TwipsPerPixelX) + ((Outer.Right - Outer.Left) - (Inner.Right - Inner.Left)) / 2, (Me.Top / Screen.TwipsPerPixelY) + ((Outer.Bottom - Outer.Top) - (Inner.Bottom - Inner.Top)) / 1.15, vbSrcCopy)
'[***** Use This Section Without Borders *****]
'ret = BitBlt(picDC.hdc, 0, 0, Me.ScaleWidth, Me.ScaleHeight, DeskHdc, Me.Left / Screen.TwipsPerPixelX, Me.Top / Screen.TwipsPerPixelY, vbSrcCopy)

ret = ReleaseDC(0&, DeskHdc)
'Show the form
SetWindowPos Me.hwnd, -2, -1, -1, 300, 200, SWP_NOMOVE + SWP_SHOWWINDOW
'Clear the pictures
Me.Cls
'Blend the final image
Blend Me, picDC, cthru, 0, 0, Me.ScaleWidth, Me.ScaleHeight
End Sub


Private Sub mhkTrap_Message(ByVal msg As Long, ByVal wp As Long, ByVal lp As Long, result As Long)
'3 Is the trap number for the WM_MOVE message
If msg = 3 Then Me.Refresh
End Sub


