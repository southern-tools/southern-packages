#!/bin/bash
# Southern Tools
#
#set -x
set -e
set -u
shopt -s nullglob

# ********************** source repos and local operations ********************* 
source ~/.user_config/no_share/git_repos

# ********************** variables ********************* 
ReposToPull=$repo_1\ $repo_2\ $repo_3\ $repo_4\ $repo_5\ $repo_6\ $repo_7\ $repo_8\ $repo_9
ReposToPush=$repo_16

# ***************** functions ****************** 

# First, check repo's config and store credentials
UserCredentials(){
	git config --global user.name
	git config --global user.email
	git config --global credential.helper store
}
RootCredentials(){
	sudo git config --global user.name
	sudo git config --global user.email
	sudo git config --global credential.helper store
}
PullRepos(){
	for repo in $ReposToPull
		do
			if [[ $(stat -c '%U' $repo) == $USER ]]
				then
					# For repos owned by user
					GitBranch=$(git -C $repo branch --show-current)
					git -C $repo pull origin $GitBranch && echo -e "*** Repository $repo pulled"
	  		elif [[ $(sudo stat -c '%U' $repo) == root ]]
	  			then
	  				# For system repos
	  				GitBranch=$(sudo git -C $repo branch --show-current)
	  				sudo git -C $repo pull origin $GitBranch && echo -e "*** Repository $repo pulled"
	  			else
	  				echo "The repo/s you are trying to Pull do not belong to the current user nor to root. Exiting..."
					exit
			fi
	done
}
PushRepos(){
	for repo in $ReposToPush
		do
			if [[ $(stat -c '%U' $repo) == $USER ]]
				then
					# For repos owned by user
					GitBranch=$(git -C $repo branch --show-current)
	  				git -C $repo add . && echo -e "*** Added files to $repo"
					git -C $repo commit -a -m "Automatic Update" && echo -e "*** Changes commited to $repo"
					git -C $repo push -u origin $GitBranch && echo -e "*** Repository $repo pushed (origin master)"
			elif [[ $(sudo stat -c '%U' $repo) == root ]]
				then
	  				# For system repos
	  				GitBranch=$(sudo git -C $repo branch --show-current)
	  				sudo git -C $repo add . && echo -e "*** Added files to $repo"
					sudo git -C $repo commit -m "Automatic Update" && echo -e "*** Changes commited to $repo"
					sudo git -C $repo push -u origin $GitBranch && echo -e "*** Repository $repo pushed (origin master)"
	  			else
	  				echo "The repos you are trying to Push do not belong to the current user nor to root. Exiting..."
	  				exit
			fi
	done
}

# *************** start of script proper ***************

# Update credentials
UserCredentials
#RootCredentials
# Pull remotes
PullRepos

# Perform local operations
Merge1
Merge2
Merge3
Merge4
Merge5
Merge6
Merge7
#Merge8
#Merge9
#Merge10

# Push repos
PushRepos

echo "*** All repos updated"
# **************** end of script proper ****************
