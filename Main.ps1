#########################################################################
# Author:  Kevin RAHETILAHY                                             #   
# Blog: dev4sys.blogspot.fr                                             #
#########################################################################

#########################################################################
#                        Add shared_assemblies                          #
#########################################################################

[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll') | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')      | out-null  

#########################################################################
#                        Load Main Panel                                #
#########################################################################

$Global:pathPanel= split-path -parent $MyInvocation.MyCommand.Definition
function LoadXaml ($filename){
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}
$XamlMainWindow=LoadXaml($pathPanel+"\Main.xaml")
$reader = (New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form = [Windows.Markup.XamlReader]::Load($reader)


$okAndCancel = [MahApps.Metro.Controls.Dialogs.MessageDialogStyle]::AffirmativeAndNegative
    

#########################################################################
#                   Initialize default control                          #
#########################################################################


$CloseBtn = $Form.findName("CloseBtn")


#########################################################################
#                        Event                                          #
#########################################################################



$CloseBtn.add_Click({
    [System.Object]$sender = $args[0]
    [System.Windows.RoutedEventArgs]$e = $args[1]
    $Form.close()
})



#########################################################################
#                        Show Dialog                                    #
#########################################################################


$Form.Add_SourceInitialized({
    Write-Host "0 - Window is Initialized"    
})

$Form.Add_Activated({
    Write-Host "*** - Oh boy! I'm on the stage"
})


$Form.Add_Loaded({
    Write-Host "1 - Only window is Loaded"
    $message = "Do you want to load the last Project ? "
    $result = [MahApps.Metro.Controls.Dialogs.DialogManager]::ShowModalMessageExternal(`
    $Form,"Window", $message ,$okAndCancel)
    If ($result -eq "Negative"){ 
        # handle with care otherwise you won't be able to close the window :D
        Write-Host "This is a new project!" 
    }
    Else{
        Write-Host "This is the last project."   
    } 
})


$Form.Add_ContentRendered({
    Write-Host "2 - Content is rendered"    
    
})


$Form.Add_Deactivated({
    Write-Host "*** - Mama! I've lost focus X)"
})


$Form.Add_Closing({
    [System.Object]$sender = $args[0]
    [System.ComponentModel.CancelEventArgs]$e = $args[1]
   
    $message = "Do you really wish to close me :( ? "
    $result = [MahApps.Metro.Controls.Dialogs.DialogManager]::ShowModalMessageExternal(`
    $Form,"Window", $message ,$okAndCancel)
    If ($result -eq "Negative"){ 
        # handle with care otherwise you won't be able to close the window :D
        $e.Cancel = $true
        Write-Host "3 - User canceled Closing." 
    }
    Else{
        Write-Host "3 - Window is Closing."   
    }   
})


$Form.Add_Closed({
    Write-Host "4 - Form closed"
})


# Another approach to launch a window
$app = [Windows.Application]::new()
$app.Run($Form) | Out-Null

# What we ued to do"
#$Form.ShowDialog() | Out-Null
  
