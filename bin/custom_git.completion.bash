#!/bin/bash

. /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash

## Gitlab Functions
_git_gitlab() {
 local subcommands="
    mr
  "

  local subcommand="$(__git_find_on_cmdline "$subcommands")"
  if [ -z "$subcommand" ]
  then
    case "${cur}" in
      *)
        __gitcomp "${subcommands}"
      ;;
    esac
  fi

  local completion_func="_gitlab_${subcommand//-/_}"
  declare -f $completion_func >/dev/null && $completion_func

  compopt +o default
}

_gitlab_mr() {
  local subcommands="
    create
  "

  local subcommand="$(__git_find_on_cmdline "$subcommands")"
  if [ -z "$subcommand" ]
  then
    case "${cur}" in
      *)
        __gitcomp "${subcommands}"
      ;;
    esac
  fi

  local completion_func="_mr_${subcommand//-/_}"
  declare -f $completion_func >/dev/null && $completion_func

  compopt +o default
}

_mr_create() {
  local dwim_opt="$(__git_checkout_default_dwim_mode)"

  case "${prev}" in
    -r|--remote)
      __gitcomp_nl "$(__git_remotes)"
      return
    ;;
    -b|--branch)
      __git_complete_refs $dwim_opt --mode="heads"
      return
    ;;
  esac

  case "${cur}" in
    --*)
      __gitcomp "--branch --open --remote"
    ;;
    -*)
      __gitcomp "-b -O -r"
    ;;
    *)
      __gitcomp "--branch --open --remote"
    ;;
  esac
  compopt +o default
}

_git_wt() {
 local subcommands="
    clone
    branch
  "
  local worktreeSubcommands="add list lock move prune remove unlock"

  local subcommand="$(__git_find_on_cmdline "$subcommands $worktreeSubcommands")"
  local worktreeSubcommand="$(__git_find_on_cmdline "$worktreeSubcommands")"
  if [ -z "$subcommand" ]
  then
    case "${cur}" in
      *)
        __gitcomp "$subcommands $worktreeSubcommands"
      ;;
    esac
  fi

  local completion_func
  if [ -z "$worktreeSubcommand" ]
  then
    completion_func="_wt_${subcommand//-/_}"
  else
    completion_func="_wt_git"
  fi

  declare -f $completion_func >/dev/null && $completion_func

  #compopt +o default

}

_wt_clone() {
  __git_complete_command clone && return
}

_wt_add() {
  local dwim_opt="$(__git_checkout_default_dwim_mode)"

  case "${prev}" in
    -b|--branch)
      __git_complete_refs $dwim_opt --mode="heads"
      return
    ;;
  esac

}

_wt_git() {
  _git_worktree
}

_wt_branch() {
  local dwim_opt="$(__git_checkout_default_dwim_mode)"
  __git_complete_refs $dwim_opt --mode="heads"
  return
}

# Worktree Switch Function and Completion
wts() {
  local worktree=$(git worktree list --porcelain | grep -E 'worktree ' | awk '/'"$1"'/ {print; exit}' | cut -d ' ' -f2-)
  cd $worktree
}

_wts() {
  local cur opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  local worktrees="$(git worktree list | grep -v '(bare)' |  awk '{ print $1; }' | tr '\n' ' ')"
  opts=""

  for item in $worktrees; do
      opts+="$(basename -- "$item") "
  done

  # Only show suggestions for the root command (wt)
  # Pass autocompletion suggestion as "words (-W)" to `compgen` separated by space
  if [[ ${cur} == -* || ${COMP_CWORD} -eq 1 ]]; then
      local cur=${COMP_WORDS[COMP_CWORD]}
      # shellcheck disable=SC2207
      COMPREPLY=($(compgen -W "$opts" -- "$cur"))
  fi
}
complete -F _wts wts
