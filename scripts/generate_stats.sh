PROJECT='homekeeping_stats'
echo 'Hash,Comments Count,Library Lines,Application Lines,Spec Lines,Spec Runtime,Number of Files,Commit Message' > file_data.csv
echo 'Hash,Covered Lines,Total Lines' > coverage_data.csv
cd $PROJECT
bash run-command-on-git-revisions e103e0d master "bin/rake db:migrate RAILS_ENV=test && cd .. && rake call_stats PROJECT='$PROJECT'&& cd $PROJECT"
