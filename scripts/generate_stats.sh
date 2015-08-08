start=$1
PROJECT='homekeeping_stats'
echo 'Hash,Comments Count,Library Lines,Application Lines,Spec Lines,Spec Runtime,Number of Files,Commit Message,Number of Total Specs,Number of Specs Pending' > file_data.csv
echo 'Hash,Covered Lines,Total Lines' > coverage_data.csv
cd $PROJECT
bash run-command-on-git-revisions $1 master "bin/rake db:migrate RAILS_ENV=test && cd .. && rake call_stats PROJECT='$PROJECT'&& cd $PROJECT"
#bash run-command-on-git-revisions e103e0d master "bin/rake db:migrate RAILS_ENV=test && cd .. && rake call_stats PROJECT='$PROJECT'&& cd $PROJECT"
