### Create form and elements
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$myForm                          = New-Object system.Windows.Forms.Form
$myForm.ClientSize               = New-Object System.Drawing.Point(400,400)
$myForm.text                     = "FRB Time Prototype"
$myForm.TopMost                  = $false
$myForm.MaximizeBox              = $False
$myForm.FormBorderStyle = 'Fixed3D'

$exitButton                      = New-Object system.Windows.Forms.Button
$exitButton.text                 = "Exit"
$exitButton.width                = 60
$exitButton.height               = 30
$exitButton.location             = New-Object System.Drawing.Point(319,350)
$exitButton.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$timeButton                      = New-Object system.Windows.Forms.Button
$timeButton.text                 = "Time"
$timeButton.width                = 60
$timeButton.height               = 30
$timeButton.location             = New-Object System.Drawing.Point(165,178)
$timeButton.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$timeLabel                       = New-Object system.Windows.Forms.Label
$timeLabel.AutoSize              = $false
$timeLabel.width                 = 200
$timeLabel.height                = 20
$timeLabel.location              = New-Object System.Drawing.Point(99,142)
$timeLabel.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$timeLabel.BackColor             = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$myForm.controls.AddRange(@($exitButton,$timeButton,$timeLabel))

### Form events go here
$timeButton.Add_Click({ time })
$exitButton.Add_Click({ $myform.Close() })
$myForm.Add_Click({ $global:formClick = $true })

### Logic for form events goes here
# Say something
# TO DO: make responsive
function speak ($param) 
{
    try 
    {
        Add-Type -AssemblyName System.speech
        $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
        $speak.Speak("The current time is $param")
    }
    catch 
    {
        $ErrorMessage = $_.Exception.Message
    }
    finally 
    {
        $global:formClick = $false
    }
}

# Print time and talk if required
# TO DO: separate logic from label
function time 
{
    try 
    {
        $date = Get-Date
        $time = Get-Date $date -Format 'HH:mm tt'
        $timeLabel.Text = $time
        if ($formClick)
        {
            speak -param $time
        }
    }
    catch 
    {
        $ErrorMessage = $_.Exception.Message
    }
}

[void]$myForm.ShowDialog()