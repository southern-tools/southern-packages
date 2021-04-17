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
ReposToCheck=$repo_1\ $repo_2\ $repo_3\ $repo_4\ $repo_5\ $repo_6\ $repo_7\ $repo_8\ $repo_9
Urls=$url_1\ $url_2\ $url_3\ $url_4\ $url_5\ $url_6\ $url_7\ $url_8\ $url_9
ReposToPull=$ReposToCheck
ReposToPush=$repo_16

# ***************** functions ****************** 

# First, check repo's config and store credentials
UserCredentials(){
	git config --global user.name
	git config --global user.email
	git config --global credential.helper store
}
ReposCheckCloned(){
	for repo in $ReposToCheck
		do
			if [[ ! -d $(echo $repo | cut -d " " -f 2) ]]
				then
					echo -e "*************************************echo $(echo $repo | cut -d " " -f 2)"
					
					#echo -e "*** Repository $repo not present, attempting to clone it..."
					#git clone $(echo $repo | cut -d " " -f 1) $(echo $repo | cut -d " " -f 2)  && echo -e "*** Repository $repo succesfully cloned"
			else
				echo -e "*** Repository $repo already exists"
			fi
	done
}
PullRepos(){
	for repo in $ReposToPull
		do
			if [[ $(stat -c '%U' $repo) == $USER ]]
				then
					# For repos owned by user
					GitBranch=$(git -C $repo branch --show-current)
					git -C $repo pull origin $GitBranch && echo -e "*** Repository $repo pulled"
	  		else
	  			echo -e "*** ERROR: One or more of repo/s you are trying to Pull do not belong to the current user.\n*** Exiting..."
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
	  		else
	  			echo -e "*** ERROR: One or more of repos you are trying to Push do not belong to the current user.\n*** Exiting..."
	  			exit
			fi
	done
}

# *************** start of script proper ***************
echo -e "*** Starting Update Git Repos."
# Update credentials
UserCredentials
# Pull remotes
#ReposCheckCloned
PullRepos

# Perform local operations
Merge1
Merge2
Merge3
Merge4
Merge5
Merge6
Merge7
# Merge8
# Merge9
# Merge10

# Push repos
PushRepos

echo -e "*** All tasks accomplished.\n*** Exiting Update Git Repos..."
# **************** end of script proper ****************
#echo $ReposToCheck