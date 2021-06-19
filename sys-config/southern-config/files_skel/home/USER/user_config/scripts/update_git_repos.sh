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
ReposToPull=(	"${repo_1[1]}"\
				"${repo_2[1]}"\
				"${repo_3[1]}"\
				"${repo_4[1]}"\
				"${repo_5[1]}"\
				"${repo_6[1]}"\
				"${repo_7[1]}"\
				"${repo_8[1]}"\
				"${repo_15[1]}")

ReposToPush=(	"${repo_16[1]}")

# ***************** functions ****************** 

# First, check repo's config and store credentials
UserCredentials(){
	git config --global user.name
	git config --global user.email
	git config --global credential.helper store
}
ReposCheckCloned(){
	for repo in ${ReposToPull[@]}
		do
			if [[ ! -d $repo ]]
				then
					missing_repo=$repo
					echo -e "*** ERROR: The repo/s $missing_repo is not locally present.\n*** Exiting..."
					exit
			fi
	done
}
PullRepos(){
	for repo in ${ReposToPull[@]}
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
	for repo in ${ReposToPush[@]}
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
ReposCheckCloned
PullRepos

# Perform local operations
merge_repos
save_portage
save_user_config

# Push repos
PushRepos

echo -e "*** All tasks accomplished.\n*** Exiting Update Git Repos..."
# **************** end of script proper ****************
