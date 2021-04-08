#!/bin/bash
# Southern Tools
#
set -x
set -e
set -u
shopt -s nullglob

# ********************** source repos and local operations ********************* 
source ~/.user_config/no_share/git_repos

# ********************** variables ********************* 
ReposToPull=$repo_1\ $repo_2\ $repo_3\ $repo_4\ $repo_5\ $repo_6\ $repo_7\ $repo_8
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
			ParseGitBranch=$(git -C $repo branch --show-current)
			if [[ $(ls -ld $repo 2>/dev/null | cut -d ' ' -f4) == $USER ]]
				then
					# For repos owned by user
					git -C $repo pull origin $ParseGitBranch
					break
	  		elif [[ $(ls -ld $repo 2>/dev/null | cut -d ' ' -f4) == root ]]
	  			then
	  				# For system repos
	  				sudo git -C $repo pull origin $ParseGitBranch
	  				break
	  			else
	  				echo "The repo/s you are trying to Pull do not belong to the current user nor to root. Exiting..."
					exit
			fi
	done
}
PushRepos(){
	for repo in $ReposToPush
		do
			if [[ $(ls -ld $repo 2>/dev/null | cut -d ' ' -f4) == $USER ]]
				then
					# For repos owned by user
	  				git -C $repo add . && echo -e "* Added files to $repo" >&2 && \
					git -C $repo commit -a -m "Automatic Update" && echo -e "* Changes commited to $repo" >&2 && \
					git -C $repo push -u origin $ParseGitBranch && echo -e "* $repo pushed (origin master)"
					break
			elif [[ $(ls -ld $repo 2>/dev/null | cut -d ' ' -f4) == root ]]
				then
	  				# For system repos
	  				sudo git -C $repo add . && echo -e "* Added files to $repo" && \
					sudo git -C $repo commit -m "Automatic Update" && echo -e "* Changes commited to $repo" >&2 && \
					sudo git -C $repo push -u origin $ParseGitBranch && echo -e "* $repo pushed (origin master)" >&2
					break				
	  			else
	  				echo "The repos you are trying to Push do not belong to the user nor root. Exiting..."
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