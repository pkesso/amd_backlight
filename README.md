# amd_backlight
backlight control script for amd based laptop

backlight_xrandr.sh - brightness only
backlight_redshift.sh - brightness and color temperature

## i3 config sample
```
bindcode 232 exec /usr/local/bin/backlight_xrandr.sh dec 0.10
bindcode 233 exec /usr/local/bin/backlight_xrandr.sh inc 0.10

bindcode 232 exec /usr/local/bin/backlight_redshift.sh dec
bindcode 233 exec /usr/local/bin/backlight_redshift.sh inc
```
