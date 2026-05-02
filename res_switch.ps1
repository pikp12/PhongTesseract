Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# ---------- Settings ----------
$settingsPath = Join-Path $PSScriptRoot "settings.json"
if (Test-Path $settingsPath) {
    $settings = Get-Content $settingsPath | ConvertFrom-Json
} else {
    $settings = @{ theme = "dark"; mica = $true }
}
function Save-Settings {
    $settings | ConvertTo-Json | Set-Content $settingsPath -Encoding UTF8
}

$accentHex = "#2B88D8"

# ---------- XAML ----------
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Width="760" Height="460"
        WindowStyle="None"
        AllowsTransparency="True"
        Background="Transparent"
        WindowStartupLocation="CenterScreen"
        FontFamily="Segoe UI Variable Text">

    <Border Name="MainBorder"
            CornerRadius="14"
            Background="#202020"
            BorderBrush="#2A2A2A"
            BorderThickness="1">

        <Grid>
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="220"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>

            <!-- Sidebar -->
            <StackPanel Name="Sidebar" Background="#1B1B1B">
                <TextBlock Name="TitleText" Text="Settings"
                           FontSize="20"
                           Foreground="White"
                           Margin="20,20,20,10"/>

                <Border Name="SelDisplay" CornerRadius="6" Margin="10,6">
                    <Button Name="NavDisplay" Background="Transparent" BorderThickness="0" Padding="10">
                        <StackPanel Orientation="Horizontal">
                            <TextBlock Text="&#xE7F4;" FontFamily="Segoe MDL2 Assets" Foreground="White" Margin="0,0,10,0"/>
                            <TextBlock Name="TxtDisplay" Text="Display" Foreground="White"/>
                        </StackPanel>
                    </Button>
                </Border>

                <Border Name="SelAppearance" CornerRadius="6" Margin="10,6">
                    <Button Name="NavAppearance" Background="Transparent" BorderThickness="0" Padding="10">
                        <StackPanel Orientation="Horizontal">
                            <TextBlock Text="&#xE790;" FontFamily="Segoe MDL2 Assets" Foreground="White" Margin="0,0,10,0"/>
                            <TextBlock Name="TxtAppearance" Text="Appearance" Foreground="White"/>
                        </StackPanel>
                    </Button>
                </Border>

                <Button Name="NavExit"
                        Margin="10,20,10,0"
                        Height="36"
                        Background="#2D2D30"
                        BorderThickness="0">
                    <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
                        <TextBlock Text="&#xE8BB;" FontFamily="Segoe MDL2 Assets" Foreground="White" Margin="0,0,8,0"/>
                        <TextBlock Name="TxtExit" Text="Exit" Foreground="White"/>
                    </StackPanel>
                </Button>
            </StackPanel>

            <!-- Content -->
            <Grid Name="ContentArea" Grid.Column="1" Background="#1E1E1E">
                <StackPanel Width="400" Margin="30">

                    <!-- DISPLAY -->
                    <StackPanel Name="PageDisplay">
                        <TextBlock Name="DisplayTitle" Text="PhongTesseract v0.1" FontSize="24" Foreground="White" Margin="0,0,0,15"/>

                        <Button Name="Btn1080" Content="1920 x 1080 (1080p)" Height="40" Margin="0,5" Background="#2D2D30" Foreground="White" BorderThickness="0"/>
                        <Button Name="Btn720" Content="1280 x 720 (720p)" Height="40" Margin="0,5" Background="#2D2D30" Foreground="White" BorderThickness="0"/>
                    </StackPanel>

                    <!-- APPEARANCE -->
                    <StackPanel Name="PageAppearance" Visibility="Collapsed">
                        <TextBlock Name="AppearanceTitle" Text="Appearance" FontSize="24" Foreground="White" Margin="0,0,0,15"/>

                        <CheckBox Name="ToggleTheme" Content="Dark mode" Foreground="White" Margin="0,5"/>
                        <CheckBox Name="ToggleMica" Content="Mica / blur effect" Foreground="White" Margin="0,5"/>
                    </StackPanel>

                </StackPanel>
            </Grid>
        </Grid>
    </Border>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# ---------- Elements ----------
$PageDisplay = $window.FindName("PageDisplay")
$PageAppearance = $window.FindName("PageAppearance")

$NavDisplay = $window.FindName("NavDisplay")
$NavAppearance = $window.FindName("NavAppearance")
$NavExit = $window.FindName("NavExit")

$SelDisplay = $window.FindName("SelDisplay")
$SelAppearance = $window.FindName("SelAppearance")

$MainBorder = $window.FindName("MainBorder")
$Sidebar = $window.FindName("Sidebar")
$ContentArea = $window.FindName("ContentArea")

$TxtDisplay = $window.FindName("TxtDisplay")
$TxtAppearance = $window.FindName("TxtAppearance")
$TxtExit = $window.FindName("TxtExit")
$TitleText = $window.FindName("TitleText")

$DisplayTitle = $window.FindName("DisplayTitle")
$AppearanceTitle = $window.FindName("AppearanceTitle")

$Btn1080 = $window.FindName("Btn1080")
$Btn720 = $window.FindName("Btn720")

$ToggleTheme = $window.FindName("ToggleTheme")
$ToggleMica = $window.FindName("ToggleMica")

# ---------- Theme ----------
function Apply-Theme {

    if ($settings.theme -eq "dark") {
        $bgMain = "#202020"
        $bgSide = "#1B1B1B"
        $bgContent = "#1E1E1E"
        $text = "White"
        $btn = "#2D2D30"
    } else {
        $bgMain = "#F3F3F3"
        $bgSide = "#EDEDED"
        $bgContent = "#FFFFFF"
        $text = "Black"
        $btn = "#E5E5E5"
    }

    $MainBorder.Background = $bgMain
    $Sidebar.Background = $bgSide
    $ContentArea.Background = $bgContent

    $TitleText.Foreground = $text
    $TxtDisplay.Foreground = $text
    $TxtAppearance.Foreground = $text
    $TxtExit.Foreground = $text
    $DisplayTitle.Foreground = $text
    $AppearanceTitle.Foreground = $text

    $Btn1080.Background = $btn
    $Btn720.Background = $btn
}

# ---------- Navigation ----------
function SwitchPage($from, $to) {
    $from.Visibility = "Collapsed"
    $to.Visibility = "Visible"
}

function SelectNav($on, $off) {
    $on.Background = $accentHex
    $off.Background = "Transparent"
}

$NavDisplay.Add_Click({
    SwitchPage $PageAppearance $PageDisplay
    SelectNav $SelDisplay $SelAppearance
})

$NavAppearance.Add_Click({
    SwitchPage $PageDisplay $PageAppearance
    SelectNav $SelAppearance $SelDisplay
})

$NavExit.Add_Click({ $window.Close() })

# ---------- Init ----------
$ToggleTheme.IsChecked = ($settings.theme -eq "dark")
Apply-Theme
SelectNav $SelDisplay $SelAppearance

# ---------- Toggle ----------
$ToggleTheme.Add_Click({
    $settings.theme = if ($ToggleTheme.IsChecked) { "dark" } else { "light" }
    Save-Settings
    Apply-Theme
})

# ---------- Resolution ----------
$Btn1080.Add_Click({ Start-Process "QRes.exe" -ArgumentList "/x 1920 /y 1080 /r 60" })
$Btn720.Add_Click({ Start-Process "QRes.exe" -ArgumentList "/x 1280 /y 720 /r 60" })

# ---------- Drag ----------
$window.Add_MouseDown({ $window.DragMove() })

$window.ShowDialog() | Out-Null