on run argv
    if (count of argv) < 1 then
        set projectDir to POSIX path of (path to home folder)
    else
        set projectDir to item 1 of argv
    end if

    tell application "Ghostty"
        activate

        set cfg to new surface configuration
        set initial working directory of cfg to projectDir

        set win to new window with configuration cfg
        set paneLeft to terminal 1 of selected tab of win
        set paneRight to split paneLeft direction right with configuration cfg
        set paneBottomLeft to split paneLeft direction down with configuration cfg

        input text "nvim ." to paneRight
        send key "enter" to paneRight

        input text "claude" to paneBottomLeft
        send key "enter" to paneBottomLeft

        focus paneRight
    end tell
end run
