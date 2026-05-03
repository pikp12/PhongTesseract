Add-Type -AssemblyName PresentationFramework

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="PhongTesseract v0.1"
        Height="420" Width="500"
        WindowStartupLocation="CenterScreen"
        ResizeMode="NoResize"
        Background="#1E1E1E">

    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="140"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>

        <!-- Sidebar -->
        <StackPanel Background="#2D2D30">
            <Button Name="NavDisplay" Content="Display" Height="40" Margin="10"/>
            <Button Name="NavAppearance" Content="Appearance" Height="40" Margin="10"/>
        </StackPanel>

        <!-- Content -->
        <Grid Grid.Column="1" Margin="15">

            <!-- DISPLAY PAGE -->
            <StackPanel Name="PageDisplay">
                <TextBlock Name="DisplayTitle" Text="Display Settings" FontSize="22" Margin="0,0,0,15"/>

                <Button Name="Btn1080" Content="1920 x 1080 (1080p)" Height="40" Margin="0,5"/>
                <Button Name="Btn900" Content="1600 x 900" Height="40" Margin="0,5"/>
                <Button Name="Btn720" Content="1280 x 720 (720p)" Height="40" Margin="0,5"/>
                <Button Name="Btn1024" Content="1024 x 768" Height="40" Margin="0,5"/>
                <Button Name="Btn800" Content="800 x 600" Height="40" Margin="0,5"/>
            </StackPanel>

            <!-- APPEARANCE PAGE -->
            <StackPanel Name="PageAppearance" Visibility="Collapsed">
                <TextBlock Text="Appearance" FontSize="22" Margin="0,0,0,15"/>
                <Button Name="BtnDark" Content="Dark Mode" Height="40" Margin="0,5"/>
                <Button Name="BtnLight" Content="Light Mode" Height="40" Margin="0,5"/>
            </StackPanel>

        </Grid>
    </Grid>
</Window>
"@

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

$NavDisplay = $window.FindName("NavDisplay")
$NavAppearance = $window.FindName("NavAppearance")

$PageDisplay = $window.FindName("PageDisplay")
$PageAppearance = $window.FindName("PageAppearance")

$Btn1080 = $window.FindName("Btn1080")
$Btn900 = $window.FindName("Btn900")
$Btn720 = $window.FindName("Btn720")
$Btn1024 = $window.FindName("Btn1024")
$Btn800 = $window.FindName("Btn800")

$BtnDark = $window.FindName("BtnDark")
$BtnLight = $window.FindName("BtnLight")

$NavDisplay.Add_Click({
    $PageDisplay.Visibility = "Visible"
    $PageAppearance.Visibility = "Collapsed"
})

$NavAppearance.Add_Click({
    $PageDisplay.Visibility = "Collapsed"
    $PageAppearance.Visibility = "Visible"
})

function Set-Res($w, $h) {
    Start-Process -FilePath ".\QRes.exe" -ArgumentList "/x:$w /y:$h" -NoNewWindow
}

$Btn1080.Add_Click({ Set-Res 1920 1080 })
$Btn900.Add_Click({ Set-Res 1600 900 })
$Btn720.Add_Click({ Set-Res 1280 720 })
$Btn1024.Add_Click({ Set-Res 1024 768 })
$Btn800.Add_Click({ Set-Res 800 600 })

function Apply-Theme($mode) {
    if ($mode -eq "Dark") {
        $window.Background = "#1E1E1E"

        foreach ($btn in @($Btn1080,$Btn900,$Btn720,$Btn1024,$Btn800,$BtnDark,$BtnLight,$NavDisplay,$NavAppearance)) {
            $btn.Background = "#2D2D30"
            $btn.Foreground = "White"
        }
    }
    else {
        $window.Background = "White"

        foreach ($btn in @($Btn1080,$Btn900,$Btn720,$Btn1024,$Btn800,$BtnDark,$BtnLight,$NavDisplay,$NavAppearance)) {
            $btn.Background = "#E5E5E5"
            $btn.Foreground = "Black"
        }
    }
}

$BtnDark.Add_Click({ Apply-Theme "Dark" })
$BtnLight.Add_Click({ Apply-Theme "Light" })
Apply-Theme "Dark"

$window.ShowDialog()
