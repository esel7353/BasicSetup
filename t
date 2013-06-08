#!/bin/bash
###############################################################################
#
#       The Toolbox Script
#
###############################################################################
# Description
#
# While working on a software project, one often uses a few script to automate
# Simple tasks (build, clean, commit, ...) Depending on the directory structure
# of the project, the commands to run the scripts can become very long. Placing
# the script in the local bin folder, is not an satisfying solution, because
# there meight be many similar scripts for different project, which need
# distinct names.
#
# This small script is designed to run these script very quickly. All scripts
# which are used for one project are stored in a folder called ".tools" located
# in the base directory of the project. Buy running
#
#   t <script name>  
#
# in any subfolder of the project the script in the tool box will be executed.
# These scripts are called tools. The whole collection of these scripts is
# calles the toolbox (of a project).
#
###############################################################################
# Copyright (C) 2013, Frank Sauerburger
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
###############################################################################
# How to use?
#
# call tool from next tool box in file system tree:
#     t <tool name>
# 
# initalize toolbox in working directory [from template]:
# or copy all tools from a template:
#     t -init [<template>]
#
# list all tools in next toolbox in file system tree:
#     t ?
#
# start vim to write new tool:
#     t -new <tool name>
#
# add current tools to template (locally):
#     t -att <tempalte name>
#
# where to put local template tools:
#     %HOME/.t/<template name>/
#
# where to put system template tools:
#     /usr/share/ttemplate/<template name>/
#
###############################################################################

# init new toolbox
if [ "$1" == "-init" ]
then
  [ -d .tools ] || mkdir .tools

  touch .tools/.toolbox.init
  echo "tool box created"

  # copy template
  if [ "$2" != "" ]
  then
    if [ -d ~/.t/$2 ]
      then 
        cp ~/.t/$2/* ./.tools/
        echo "  from local template"
      else
        if [ -d /usr/share/ttemplate/$2 ]
          then 
            cp /usr/share/ttemplate/$2
            echo "  from system template"
        fi
    fi
  fi
  exit 0
fi

# search next toolbox
for i in {1..100}
do
  # toolbox found
  if [ -f ./.tools/.toolbox.init ]
  then
    echo "using tools of $PWD"

    # add to template
    if [ "$1" == "-att" ]
    then
      [ -d ~/.t/ ] || mkdir ~/.t/
      [ -d ~/.t/$2/ ] || mkdir ~/.t/$2/
      cp ./.tools/* ~/.t/$2/
      echo "all sctipts added to local template"
      exit 0
    fi

    # list tools
    if [ "$1" = "?" ]
    then
      ls ./.tools/
      exit 0
    fi
       
    # make new tool
    if [ "$1" == "-new" ]
    then
      vim $PWD/.tools/$2
      chmod u+x $PWD/.tools/$2
      exit 0
    fi

    # run tool
    if [ -f ./.tools/$1 ]
      then ./.tools/$1 $2 $3 $4 $5 $6 $7 $8 $9
      else echo "no such tool"
    fi
    exit 0
  fi

  # reached root folder
  if [ "$PWD" == "/" ]
  then
      echo "no toolbox found (/)"
      exit 1
  fi
  cd ..
done

echo "no toolbox found (100)"
exit 1
