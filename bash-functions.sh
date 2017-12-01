#!/bin/bash
# Collection of functions

todo(){ cd ~/.todo||return 1&& l=$(ls -1t|head -n1)&& t=$(date +%Y%m%d);[[ "$1" == "last" ]]&&cp $l $t; ${EDITOR:-vi} $t;cd -;}

# Count Apache requests $1 filename
apache_requests(){
    awk '{print $4}' $1 | sort -n|cut -c1-15|uniq -c|awk '{b="";for(i=0;i<$1/10;i++) {b=b"#"}; print $0 " " b;}'
}

sshs() {
    ssh $@ "cat > /tmp/.bashrc_temp" < ~/dotfiles/bash-functions.sh  
    ssh -t $@ "bash --rcfile /tmp/.bashrc_temp ; rm /tmp/.bashrc_temp"
}
