# Configuring Our Prompt
# ======================

  # if you install git via homebrew, or install the bash autocompletion via homebrew, you get __git_ps1 which you can use in the PS1
  # to display the git branch.  it's supposedly a bit faster and cleaner than manually parsing through sed. i dont' know if you care 
  # enough to change it

  # This function is called in your prompt to output your active git branch.
  function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
  }

  # This function builds your prompt. It is called below
  function prompt {
    # Define some local colors
    local         RED="\[\033[0;31m\]" # This syntax is some weird bash color thing I never
    local   LIGHT_RED="\[\033[1;31m\]" # really understood
    local        CHAR="♥"
    local   BLUE="\[\e[0;49;34m\]"

    # ♥ ☆ - Keeping some cool ASCII Characters for reference

    # Here is where we actually export the PS1 Variable which stores the text for your prompt
    export PS1="\[\e]2;\u@\h\a[\[\e[37;44;1m\]\t\[\e[0m\]]$RED\$(parse_git_branch) \[\e[32m\]\W\[\e[0m\]\n\[\e[0;31m\]$BLUE//$RED $CHAR \[\e[0m\]"
      PS2='> '
      PS4='+ '
    }

  # Finally call the function and our prompt is all pretty
  prompt

  # For more prompt coolness, check out Halloween Bash:
  # http://xta.github.io/HalloweenBash/

  # If you break your prompt, just delete the last thing you did.
  # And that's why it's good to keep your dotfiles in git too.

# Environment Variables
# =====================
  # Library Paths
  # These variables tell your shell where they can find certain
  # required libraries so other programs can reliably call the variable name
  # instead of a hardcoded path.

    # NODE_PATH
    # Node Path from Homebrew I believe
    export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"

    # Those NODE & Python Paths won't break anything even if you
    # don't have NODE or Python installed. Eventually you will and
    # then you don't have to update your bash_profile

  # Configurations

    # GIT_MERGE_AUTO_EDIT
    # This variable configures git to not require a message when you merge.
    export GIT_MERGE_AUTOEDIT='no'

    # Editors
    # Tells your shell that when a program requires various editors, use sublime.
    # The -w flag tells your shell to wait until sublime exits
    export VISUAL="subl -w"
    export SVN_EDITOR="subl -w"
    export GIT_EDITOR="subl -w"
    export EDITOR="subl -w"

  # Paths

    # The USR_PATHS variable will just store all relevant /usr paths for easier usage
    # Each path is seperate via a : and we always use absolute paths.

    # A bit about the /usr directory
    # The /usr directory is a convention from linux that creates a common place to put
    # files and executables that the entire system needs access too. It tries to be user
    # independent, so whichever user is logged in should have permissions to the /usr directory.
    # We call that /usr/local. Within /usr/local, there is a bin directory for actually
    # storing the binaries (programs) that our system would want.
    # Also, Homebrew adopts this convetion so things installed via Homebrew
    # get symlinked into /usr/local
    export USR_PATHS="/usr/local:/usr/local/bin:/usr/local/sbin:/usr/bin"

    # Hint: You can interpolate a variable into a string by using the $VARIABLE notation as below.

    # We build our final PATH by combining the variables defined above
    # along with any previous values in the PATH variable.

    # Our PATH variable is special and very important. Whenever we type a command into our shell,
    # it will try to find that command within a directory that is defined in our PATH.
    # Read http://blog.seldomatt.com/blog/2012/10/08/bash-and-the-one-true-path/ for more on that.
    export PATH="$USR_PATHS:$PATH"

    # If you go into your shell and type: echo $PATH you will see the output of your current path.
    # For example, mine is:
    # /Users/avi/.rvm/gems/ruby-1.9.3-p392/bin:/Users/avi/.rvm/gems/ruby-1.9.3-p392@global/bin:/Users/avi/.rvm/rubies/ruby-1.9.3-p392/bin:/Users/avi/.rvm/bin:/usr/local:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/local/mysql/bin:/usr/local/share/python:/bin:/usr/sbin:/sbin:

# Helpful Functions
# =====================

# A function to CD into the desktop from anywhere
# so you just type desktop.
# HINT: It uses the built in USER variable to know your OS X username

# USE: desktop
#      desktop subfolder
function desktop {
  cd /Users/$USER/Desktop/$@
}

# A function to easily grep for a matching process
# USE: psg postgres
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

# A function to extract correctly any archive based on extension
# USE: extract imazip.zip
#      extract imatar.tar
function extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)  tar xjf $1      ;;
            *.tar.gz)   tar xzf $1      ;;
            *.bz2)      bunzip2 $1      ;;
            *.rar)      rar x $1        ;;
            *.gz)       gunzip $1       ;;
            *.tar)      tar xf $1       ;;
            *.tbz2)     tar xjf $1      ;;
            *.tgz)      tar xzf $1      ;;
            *.zip)      unzip $1        ;;
            *.Z)        uncompress $1   ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# A function to git clone a repo, cd into the newly created folder,
# and open all the repo's files in Sublime Text 3
# USE: gclsubl git@github.com:ktravers/crowdfunding-sql-lab-ruby-007.git
# credit: Jeremy Sklarsky (http://jeremysklarsky.github.io/)
# function gclsubl () {
#           git clone $1;
#           cd `basename $1 .git`;                      # in bash, everything between backticks
#           open . -a /Applications/Sublime\ Text.app;  # will be replaced with the output of the command.
#                                                       # basename chops off the path from the file name
# }                                                     # .git removes the file extension

# A function that clones a repo, cd into the new folder, and opens the README.md in the default editor for .md files
# USE: gclread git@github.om:ktravers/crowdfunding-sql-lab-ruby007.git
# function gclread () {
#           git clone $1;
#           cd `basename $1 .git`;                      
#           open README.md;                           
# }

# A function that clones a repo, cd into the new folder, creates and checkouts onto a new branch called "wip-revision" and opens the README.md in the default editor for .md files
# USE: gclrevread git@github.om:ktravers/crowdfunding-sql-lab-ruby007.git
# function gclrevread () {
#           git clone $1;
#           cd `basename $1 .git`;                      
#           git checkout -b wip-revision;
#           open README.md;                             
# }

# A function that clones a repo, cd into the new folder, creates and checkouts onto a new branch called "wip-style" and opens the README.md in the default editor for .md files
# USE: gclstyleread git@github.om:ktravers/crowdfunding-sql-lab-ruby007.git
# function gclstyleread () {
#           git clone $1;
#           cd `basename $1 .git`;                      
#           git checkout -b wip-style;
#           open README.md;                             
# }

# function gcampstyle () {
#   git commit -am "style edits"
#   git push
# }

# A function that clones a repo, cd into the new folder, and opens the Xcode workspace
# USE: gclxcw git@github.om:ktravers/crowdfunding-sql-lab-ruby007.git
function gclxcw () {
          git clone $1;
          cd `basename $1 .git`;                      
          open *xcworkspace;                          
}

# Removes the Pods file, Podfile, and Podfile.lock from the current directory.
# function unpodulate () {
#   rm -rf Pods;
#   echo "Deleting Pods"
#   rm Podfile.lock;
#   echo "Deleting Podfile.lock"
#   rm Podfile;
#   echo "Deleting Podfile"
#   rm -rf *.xcworkspace;
#   echo "Deleting *.xcworkspace folder"
#   echo "To remove the warnings, delete the Pods targets from the project Config settings from within Xcode."
# }    

# Sets the upstream for the branch name submitted as an argument
# USE: gitupstream wip-development
# calls "git branch --set-upstream-to=origin/wip-development wip-development"
function gitupstream () {
  git branch --set-upstream-to=origin/$1 $1
}

# function setupForLearn () {
#   cp ~/Development/LearnCo/LICENSE.md .
#   echo "copied LICENSE.md"
#   cp ~/Development/LearnCo/CONTRIBUTING.md .
#   echo "copied CONTRIBUTING.md"
#   cp ~/Development/LearnCo/.learn .
#   echo "copied .learn"
#   cp ~/Development/LearnCo/.gitignore .
#   echo "copied .gitignore"
#   cp ~/Development/LearnCo/.gitattributes .
#   echo "copied .gitattributes"
#   cp ~/Development/LearnCo/test_runner.sh .
#   echo "copied test_runner.sh"
#   echo "manually add the post-script action to the Xcode scheme"
#   echo "manually create a README.md file"
# }

# usage example: $ finderShowHidden YES
function finderShowHidden () {
  defaults write com.apple.finder AppleShowAllFiles $1
  killall Finder /System/Library/CoreServices/Finder.app
}

#usage examples: $ repod
#                $ repod -u
function repod () {
  rm Podfile.lock
  while test $# -gt 0; do
    case "$1" in
      -u|--update)
        pod repo update
        shift
        ;; 
      *)
        break
        ;;
    esac
  done
  pod install
}



# Aliases
# =====================
  # LS
  alias l='ls -lah'

  alias CD="cd"
  alias LS="ls"

  # Git
  alias gcl="git clone"
  alias gst="git status"
  alias gl="git log"
  alias gpl="git pull"
  alias gpu="git push"
  alias gpuall="git push --all"
  alias gd="git diff | mate"
  alias gcam="git commit -am"
  alias gb="git branch"
  alias gba="git branch -a"
  alias gbb="git branch -b"
  alias gbd="gir branch -d"
  alias grv="git remote -v" #groovy
  alias gco="git checkout"
  alias gcob="git checkout -b"
  alias sol="git co solution"
  alias mas="git co master"
  #alias mermas="git merge master"

  # from Zadr
  alias oops="git commit --amend"
  alias reword="git commit --amend"
  alias squish="git rebase -i HEAD~2"
  alias squash="git rebase -i HEAD~2"
  alias squaash="git rebase -i HEAD~3"
  alias squaaash="git rebase -i HEAD~4"
  alias squaaaash="git rebase -i HEAD~5"

  # custom
  alias xcw="open *xcworkspace"
  alias xcode="open *xcodeproj"
  alias pbx="subl *.xcodeproj/project.pbxproj"
  alias info="subl */Info.plist"
  alias readme="open README.md"
  alias changelog="open CHANGELOG.md"
  alias relnotes="open RELEASE_NOTES.md"
  alias podfile="subl Podfile"
  alias podf="subl Podfile"
  alias podulate="pod install"
  alias podclean="rm -rf Pods"

  # squad
  alias Dev="git co Development"
  alias merDev="git merge Development"
  alias dos="git co dosamigos"
  alias merdos="git merge dosamigos"

# Case-Insensitive Auto Completion
  bind "set completion-ignore-case on" 

# Final Configurations and Plugins
# =====================
  # Git Bash Completion
  # Will activate bash git completion if installed
  # via homebrew
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
  fi

  # RVM
  # Mandatory loading of RVM into the shell
  # This must be the last line of your bash_profile always
  source ~/.profile


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
