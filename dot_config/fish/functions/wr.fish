function wr --description 'cd to the root of the current git worktree/branch'
    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$root"
        echo "wr: not inside a git worktree" >&2
        return 1
    end
    cd $root
end
