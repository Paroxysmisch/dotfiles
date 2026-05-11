function grace-code --description "Connect to Grace GH200 and launch OpenCode with an anchored tunnel"
    set -l socket "/tmp/grace-socket-$USER"
    set -l ollama_bin "/home/ys562/.local/bin/ollama"

    # 1. Cleanup any existing stale sockets or hung tunnels
    if test -S $socket
        echo "Cleaning up old socket..."
        ssh -S $socket -O exit grace >/dev/null 2>&1
        rm -f $socket
    end
    # Ensure the local port is free
    pkill -f "11434:127.0.0.1:11434" >/dev/null 2>&1

    # 2. Establish the Master Connection (The "Anchor")
    # -M (Master), -S (Socket path), -f (Background), -N (No command), -T (No TTY)
    # This keeps the tunnel open regardless of what commands we send later.
    echo "Establishing secure tunnel to Grace GH200..."
    ssh -M -S $socket -fNT -L 11434:127.0.0.1:11434 -o "RemoteCommand=none" grace

    if not test $status -eq 0
        echo (set_color red)"Failed to establish SSH tunnel."(set_color normal)
        return 1
    end

    # 3. Start Ollama (Piggybacking on the Master Socket)
    echo "Waking up Ollama..."
    ssh -S $socket grace "fish -l -c 'nohup $ollama_bin serve > /dev/null 2>&1 &'"

    # 4. Verification Loop: Wait for the API to respond through the tunnel
    echo "Waiting for API to bridge..."
    set -l attempt 1
    while not curl -s -m 2 http://127.0.0.1:11434/api/tags > /dev/null
        if test $attempt -gt 15
            echo (set_color red)"Timeout: Could not reach Ollama API."(set_color normal)
            ssh -S $socket -O exit grace
            return 1
        end
        echo "  Attempt $attempt: Waiting for GH200..."
        sleep 2
        set attempt (math $attempt + 1)
    end

    echo (set_color green)"SUCCESS: Connected to GH200 GPU!"(set_color normal)

    # 5. Setup Environment and Launch OpenCode
    # Pointing to the local end of our bridged tunnel
    set -gx OPENAI_API_BASE "http://127.0.0.1:11434/v1"
    
    if type -q opencode
        echo "Launching OpenCode..."
        opencode $argv
    else
        echo (set_color yellow)"Warning: 'opencode' command not found in local PATH."(set_color normal)
    end

    # 6. Final Cleanup: Shut down the Master Tunnel
    echo "Closing tunnel and cleaning up..."
    ssh -S $socket -O exit grace >/dev/null 2>&1
    rm -f $socket
end
