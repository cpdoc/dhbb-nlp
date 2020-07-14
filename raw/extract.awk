
function cprint(var){
    gsub(/\n/," ", var);
    gsub(/[ ]+/," ",var);
    gsub(/^[ ]*/,"",var);
    gsub(/[ ]*$/,"",var);
    print var;
}    


BEGIN { text=0; cpar=""; state=0; }

/^---$/ && state==0 { state=1; next; }

/^---$/ && state==1 { state=2; next; }

$0 ~ /^#/     && state==2 { next; }
$0 ~ /^[ ]*$/ && state==2 { next; }

$0 !~ /^[ ]*$/ && state==2 {
    cpar  = $0;
    state = 3;
    next;
}

$0 ~ /^[ ]*$/ && state==3 {
    cprint(cpar);
    state=2;
    cpar = "";
    next;
}    

$0 !~ /^[ ]*$/ && state==3 {
    cpar = cpar " " $0;
    next;
}

END {
    if(length(cpar)>0) cprint(cpar);
}    


