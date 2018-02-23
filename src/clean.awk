BEGIN {OFS="\t";}
$0 ~ /^[0-9]/ {$5="_"; gsub(/^(SpacesAfter|SpacesBefore)=(\\n)+$/,"_",$10)}
{print}
