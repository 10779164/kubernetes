#/bin/bash
#Called like: choose <default (y or n)> <prompt> <yes action> <no action>
function choose {
    local default="$1"
    local prompt="$2"
    local choice_yes="$3"
    local choice_no="$4"
    local answer
    read -p "$prompt" answer
    [ -z "$answer" ] && answer="$default"
    case "$answer" in
    [yY1] )
        exec "$choice_yes"
        ;;
    [nN0] )
        exec "$choice_no"
        ;;
    * )
        printf "%b" "Unexpected answer '$answer'!" >&2
        ;;
    esac
}

#choose Y "please input:" "echo yes" "echo no"
