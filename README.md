Assumptions:

Whenever ChatBot launches server for deployment it will launch the server with Branch tag(value would be feature branch name)
This will work for Single monolithic repo where all the feature development happens in branches(however we can modify the code for multiple repos if needed)
This code support both ways IAM role / aws keys (they should have proper access to terminate instance)

Underlying technology :
I have used Ruby and couple of libraries aws-sdk and github_api for making calls to aws and github.

Prerequisite : Should have Ruby and bundler installed mostly the latest once i have tested this using the following version of Ruby - 2.2  and bundler - 1.11.2


git clone https://github.com/priya23/monitoring
Cd monitoring/problem\ 2/
bundle install

Edit the config file “config.yml” with the appropriate configuration where we will store our token,organisation name,repository name etc.all the scripts will read from this file.
The script is divided in two classes one for Github information and other file for aws related information. Run the following command to terminate the instances it will output the instance ids of deleted instances.


ruby monitoring.rb 