#!/bin/bash
# Southern Tools
#
#set -x

# Source repo names
source ~/.user_config/no_share/github_repos

# First, check repo's config and store credentials
# For regular user
git config --global user.name && \
git config --global user.email && \
git config --global credential.helper store && \
# For system user
#sudo git config --global user.name && \
#sudo git config --global user.email && \
#sudo git config --global credential.helper store && \


# Automate the branch
parse_git_branch=$(git symbolic-ref HEAD 2>/dev/null | cut -d "/" -f 3)

# Loop with different repos
for repo in "$repo_1" "$repo_2" "$repo_3" "$repo_4" "$repo_5" "$repo_6" "$repo_7" #"$repo_8" "$repo_9" "$repo_10"
	do
		if [[ $(ls -ld $repo 2>/dev/null | cut -d ' ' -f4) == $USER ]]
			then
				# For repos owned by user
				git -C $repo pull origin $parse_git_branch
  				#git -C $repo add . && echo -e "* Added files to $repo" >&2 && \
				#git -C $repo commit -a --allow-empty-message && echo -e "* Changes commited to $repo" >&2 && \
				#git -C $repo push -u origin $parse_git_branch && echo -e "* $repo pushed (origin master)"
  			else
  				# For system repos
  				#sudo git -C $repo pull origin $parse_git_branch
  				#sudo git -C $repo add . && echo -e "* Added files to $repo" && \
				#sudo git -C $repo commit -a --allow-empty-message && echo -e "* Changes commited to $repo" >&2 && \
				#sudo git -C $repo push -u origin $parse_git_branch && echo -e "* $repo pushed (origin master)" >&2
				exit
		fi

done

echo "* ALL REPOS PULLED ;)"
