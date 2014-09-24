"""
Fabric deploy script
Use this script to deploy code to production server.

For help, type:
    $fab --list OR fab -l

To deploy execute:
    fab deploy: username
    fab deploy: primal1
"""

from fabric.api import *
from fabric.contrib.console import confirm

env.hosts = ['ebserv1.cs.umbc.edu']
#TODO: Add test server to the list and access it by list index

def help(command):
    """
    Usage: fab help:command_name
    Displays the doc string for a command
    """
    from fabric.main import display_command
    display_command(command)

def copy():
    """
    Copies production directory on local machine to server
    """
    user_directory = '/home/%s/face_block' %(env.user)
    # make sure the directory is there!
    run('mkdir -p %s' %(user_directory))

    # transferring to face_block directory in home folder
    put('production', '%s' %(user_directory))

    production_directory = '/home/websites/ebiquity/v2.01/face_block/'
    #copying over to websites directory with sudo permissions
    if confirm("copying to %s from %s, continue?" %(user_directory, production_directory), default=False):
        sudo('cp  %s/*  %s' %(user_directory, production_directory))

def deploy(username):
    """
        Set username and executes copy.
        TODO: Add optional parameter for choosing between production and staging server
    """
    env.user = username
    copy()
