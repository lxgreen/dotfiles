nvim --listen /tmp/nvim.pipe && sleep 1 && nvim --server /tmp/nvim.pipe --remote-send 's'
