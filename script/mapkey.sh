spare_modifier="Super_L"
echo $spare_modifier
xmodmap -e "keycode 23 = $spare_modifier"
xmodmap -e "remove mod4 = $spare_modifier"
xmodmap -e "add Win = $spare_modifier"
xmodmap -e "add mod4 = $spare_modifier"
xmodmap -e "keycode any = Tab"
xcape -e "$spare_modifier=Tab"
