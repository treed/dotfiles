alias s='ssh -A'
alias ..='cd ..'
alias spr="curl -F 'sprunge=<-' http://sprunge.us"
alias ack='ack-grep -a'

# Ledger stuff
export LEDGER_FILE=~/ledger.dat
alias funds="ledger --no-cache -d \"l<=3\" bal Funds"
alias cash="ledger --no-cache -d \"l<=4\" bal Assets:Bank Assets:Cash Liabilities:CC"

if [ "$HOSTNAME" = "treed-laptop" ]; then
    source ~/.bash_aliases_imvu
fi

if [ "$HOSTNAME" = "wyoming" ]; then
    export PATH=$PATH:/home/treed/android-sdk-linux_86/tools:/home/treed/local/rakudo/bin
fi

function edit {
    FOUND=$(find . -name $1)
    NUM_FOUND=$(echo $FOUND | wc -l)
    if [ $NUM_FOUND -eq 0 ]; then
        echo "None found."
        return
    elif [ $NUM_FOUND -gt 1 ]; then
        echo "Many found:"
        echo $FOUND
        return
    else
        if ps x | grep -q [g]vim; then
            gvim --remote-send ":tabnew $PWD/$FOUND<CR>"
        else
            gvim $FOUND;
        fi
    fi
}
