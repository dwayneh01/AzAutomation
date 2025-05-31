num=$(ls ./templates/* | wc -l | xargs)
echo $num
count=$(( num-1 ))
echo $count
for (( i=1; i<=${count}; i++ ))
do 
data+=("${{ github.event.issue.title }}-template-${i}")
done
json=$(printf '%s\n' "${data[@]}" | jq -R . | jq -s .)
echo "files=$json >> $GITHUB_OUTPUT" 