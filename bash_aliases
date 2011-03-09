alias ssh='ssh -A'
alias s='ssh'
alias super='ssh superadmin.imvu.com'
alias hydra='ssh hydra'
alias ..='cd ..'
alias spr="curl -F 'sprunge=<-' http://sprunge.us"
alias ack='ack-grep -a'

# Ledger stuff
export LEDGER_FILE=~/ledger.dat
alias funds="ledger --no-cache -d \"l<=3\" bal Funds"
alias cash="ledger --no-cache -d \"l<=4\" bal Assets:Bank Assets:Cash Liabilities:CC"

if [ "$HOSTNAME" = "treed-laptop" ]; then
    alias codepush='rsync -ruvz --delete --exclude=.git /home/treed/code/operations/ superadmin.imvu.com:/home/treed/code/operations/'
    alias codepull='rsync -ruvz superadmin.imvu.com:/home/treed/code/operations/ /home/treed/code/operations/'
    function pull() { git mv $1 $1.pulled && git commit -m "Pulled test $1"; }
    alias super='ssh -A superadmin.imvu.com'
    alias hydra='ssh -A hydra'
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
