$0 ~ /<Lregion[^>]/ {print gensub(/<Lregion[^>]/, "<Lregion> ", 1, $0); next}
$0 ~ /<conv[^>]/ {print gensub(/<conv[^>]/, "<conv> ", 1, $0); next}
$0 ~ /<H[ ]/ {print gensub(/<H[ ]/, "<H> ", 1, $0); next}
$0 ~ /<advl>>/ {print gensub(/<advl>>/, "<advl>", 1, $0); next}
$0 ~ /<fpost\/acpormenor:4>>/ {print gensub(/<fpost\/acpormenor:4>>/, "<fpost/acpormenor:4>", 1, $0); next}
 {print}
