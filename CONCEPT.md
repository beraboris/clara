The problem
===========

I always find myself having to copy files from one machine to another. This
happens quite a lot for any number of reasons. Whenever I install these config
files I always end up screwing something up. Problems with config files come in
all shapes and sizes. Here are a few examples:

- using an old version
- config has system specific settings
- forgetting to install a config
- forgetting a file
- excess functionality
- etc.

The fact of the matter is that installing config files can easily become a
pain. Every time I install a config I end up having to crack open vim, because
something isn't quite right.

The goal
========

I want a utility that will allow me to install, uninstall, update and sync my
config files without hassle. I want a standard way of scripting config file
installation. I want to be able to select which parts of a config I need. I want
to select the parameters of some settings.

Features
========

What follows is a list of specific features for clara. Consider this some kind
of a wish list.

Handle configuration files like packages
----------------------------------------

A config file or a set of config files should be considered a package. They can
be installed, uninstalled and updated.  A package to contain all the information
needed to assemble a set of config files and install them on a system. In the
same maner, a package should contain all the information needed to get rid of a
set of configs.

Clara should act like any package manager. It needs to be able to install,
uninstall and update package. It also needs to keep track of said
packages. Anything that apt, yum, or pacman can do should be doable with clara.

Template config files
----------------------

We should be able to generalize config files so that they can bring the same
configuration in different environment.

Take the following example:

I have a config file for an unnamed application, this config file requires my
external ip address to do some cool thing.  To install this config file, I need
to look up my external ip address and set it manually.

Wouldn't it be great to be able to do something like:

    # Configuration file for some cool application
    EXTERNAL_IP = <%= call_remote_service_and_get_external_ip %>

Here's another example:

Suppose you have configured your desktop environment to start your wireless
network manager in a specific way. Now suppose that you're installing this
config on a machine with no wifi card.

Instead of having to remove a bit of the config, wouldn't it be nicer to do
something like:

    <% if wants :wifi_magic %>
    # that awesome bit of wifi config
    # . . .
    <% end %>

Or even:

    <%= comment_unless wants :wifi_magic do %>
    # that awesome bit of wifi config
    # . . .
    <% end %>

Decentralized repositories
--------------------------

Having a centralized repository of config files makes no sense. Everyone has
their own set of configurations that they like. Instead of having a few massive
repos filled with config packages, users should maintain and share their own
repositories.

These repos can be hosted anywhere the users want. They can be private, or they
can be open to the public at large. The protocols used to talk to the repos
(HTTP, FTP, SMB, etc.) don't really matter. One good platform for repos would be
github. It would be the equivalent of the dotfiles repos found all over
github. Instead of just containing only holding config files, they would hold
instructions for clara on how to install these configs.

If I find a nice config file on github, I can add the git repo to my list of
repositories and then install the config package with clara.
