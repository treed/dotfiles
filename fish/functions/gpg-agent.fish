function gpg-agent
    set -l grepped (pgrep gpg-agent)
    if begin
        set -q SSH_AGENT_PID
        and [ "$SSH_AGENT_PID" = "$grepped" ]
    end
        echo "gpg-agent running on pid $SSH_AGENT_PID"
    else
        set -e SSH_AGENT_PID
        set -e SSH_AUTH_SOCK
        set -e GPG_AGENT_INFO
        eval (command gpg-agent --daemon -c | sed 's/^setenv /set -Ux /')
    end
end
