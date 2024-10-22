#!/bin/bash

# Rofi menu to control Philips Hue lights using openhue

# Fetch cached lights, rooms, and scenes
data_dir="$HOME/.cache/openhue"
lights_cache_file="$data_dir/openhue_lights_cache"
rooms_cache_file="$data_dir/openhue_rooms_cache"
scenes_cache_file="$data_dir/openhue_scenes_cache"
colors_file="$data_dir/openhue_colors"
# 
# Ensure colors file exists with predefined colors
if [ ! -f "$colors_file" ]; then
    mkdir -p "$data_dir"
    cat <<EOL > "$colors_file"
moccasin
linen
crimson
dark_golden_rod
pale_golden_rod
khaki
light_blue
sienna
old_lace
dark_sea_green
medium_spring_green
blue
golden_rod
dark_blue
dark_magenta
navajo_white
light_slate_gray
medium_violet_red
antique_white
honeydew
yellow
green
chartreuse
deep_sky_blue
beige
peach_puff
aqua_marine
silver
dark_orange
light_cyan
mint_cream
snow
magenta
light_coral
lime_green
medium_blue
plum
dark_gray
salmon
blue_violet
blanched_almond
ivory
tan
tomato
coral
orange
dark_khaki
wheat
light_golden_rod_yellow
midnight_blue
saddle_brown
rosy_brown
olive
dark_green
medium_orchid
pink
gainsboro
lime
maroon
forest_green
medium_slate_blue
hot_pink
chocolate
red
firebrick
lawn_green
spring_green
pale_turquoise
dodger_blue
dark_red
cadet_blue
light_pink
sandy_brown
aqua
dark_slate_gray
sky_blue
bisque
fuchsia
green_yellow
corn_silk
light_steel_blue
ghost_white
navy
orange_red
sea_green
dark_cyan
steel_blue
pale_violet_red
dim_gray
violet
slate_gray
white
brown
light_green
medium_aqua_marine
light_sea_green
dark_turquoise
purple
thistle
lemon_chiffon
papaya_whip
gray
teal
indian_red
slate_blue
light_gray
medium_purple
orchid
light_yellow
misty_rose
yellow_green
turquoise
lavender
azure
light_salmon
olive_drab
pale_green
deep_pink
peru
dark_violet
sea_shell
medium_sea_green
powder_blue
royal_blue
dark_salmon
medium_turquoise
corn_flower_blue
light_sky_blue
lavender_blush
dark_slate_blue
burly_wood
floral_white
cyan
dark_orchid
white_smoke
gold
dark_olive_green
indigo
alice_blue
EOL
fi

# Fetch lights, rooms, and scenes data
lights=$(cat "$lights_cache_file" 2>/dev/null || echo "")
rooms=$(cat "$rooms_cache_file" 2>/dev/null || echo "")
scenes=$(cat "$scenes_cache_file" 2>/dev/null || echo "")
colors=$(cat "$colors_file" 2>/dev/null || echo "")

# Generate menu options
menu_options=""

if [ -n "$lights" ]; then
    menu_options+=$'Lights:\n'
    while IFS= read -r light; do
        menu_options+="  $light\n"
    done <<< "$lights"
fi

if [ -n "$rooms" ]; then
    menu_options+=$'Rooms:\n'
    while IFS= read -r room; do
        menu_options+="  $room\n"
    done <<< "$rooms"
fi

if [ -n "$scenes" ]; then
    menu_options+=$'Scenes:\n'
    while IFS= read -r scene; do
        menu_options+="  $scene\n"
    done <<< "$scenes"
fi

# Use rofi to display the menu
chosen=$(echo -e "$menu_options" | rofi -dmenu -i -p "OpenHue Control")

if [ -z "$chosen" ]; then
    exit 0
fi

# Remove leading spaces from the chosen item
chosen=$(echo "$chosen" | sed 's/^ *//')

# Perform the action based on the chosen item
if grep -q "$chosen" <<< "$lights"; then
    action=$(echo -e "on\noff\nbrightness\ncolor" | rofi -dmenu -i -p "Action for light $chosen")
    if [ "$action" = "on" ]; then
        openhue set light "$chosen" --on
    elif [ "$action" = "off" ]; then
        openhue set light "$chosen" --off
    elif [ "$action" = "brightness" ]; then
        brightness=$(echo -e "10\n20\n30\n40\n50\n60\n70\n80\n90\n100" | rofi -dmenu -i -p "Set brightness (0-100) for light $chosen")
        if [[ "$brightness" =~ ^[0-9]+$ ]] && [ "$brightness" -ge 0 ] && [ "$brightness" -le 100 ]; then
            openhue set light "$chosen" --brightness "$brightness"
        fi
    elif [ "$action" = "color" ]; then
        color=$(echo "$colors" | rofi -dmenu -i -p "Set color for light $chosen")
        if [ -n "$color" ]; then
            openhue set light "$chosen" --color "$color"
        fi
    fi
elif grep -q "$chosen" <<< "$rooms"; then
    action=$(echo -e "on\noff" | rofi -dmenu -i -p "Action for room $chosen")
    if [ "$action" = "on" ]; then
        openhue set room "$chosen" --on
    elif [ "$action" = "off" ]; then
        openhue set room "$chosen" --off
    fi
elif grep -q "$chosen" <<< "$scenes"; then
    openhue set scene "$chosen"
fi
