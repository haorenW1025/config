killall -q polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log  /tmp/polybar2.log

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload system >>/tmp/polybar1.log 2>&1 &
  done
else
  polybar --reload system >>/tmp/polybar1.log 2>&1 &
fi

echo "Bars launched..."
