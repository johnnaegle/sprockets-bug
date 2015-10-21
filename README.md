# sprockets-bug

This is a self contained application and virtual machine environment to reproduce
https://github.com/rails/sprockets/issues/127.  I could only reproduce this on a
linux environment, never locally.  I wanted to be convienced that upgrading from
sprockets 3.3.3 to sprockets 3.4.0 fixed old assets being included in a manifest file.

# Steps

You'll need virtual box running on your machine to host a Ubuntu Virtual machine.
Capistrano is configured to deploy to this virtual machine where you should
see issue #96 reproduced.

## OSX Instructions using Homebrew

Your Milage May Vary

### Ansible / Vagrant preconditions

- install Vagrant: https://www.vagrantup.com/downloads.html
- install virtual box: https://www.virtualbox.org/
- brew install ansible python
- pip install ansible paramiko PyYAML Jinja2 httplib2 boto six cryptography

###  Setup the VM and Deploy the Code

- fork the repository
- modify url_repo in deploy.rb
```
set :repo_url, 'git@github.com:johnnaegle/sprockets-bug.git'
```
- Setup the virtual machine, this will take a while.  Gist of setup to compare: https://gist.github.com/johnnaegle/850aed529f4849abcc94
```
vagrant up
```
- Modify /etc/hosts
```
192.168.50.8 www.sprockets-master
192.168.50.8 sprockets-master
```
- (Optional) Modify .ssh/config
```
Host sprockets-master
  HostName 192.168.50.8
  User vagrant
  Port 22
  IdentityFile <PATH TO REPO>/ansible/.vagrant/machines/sprockets-master/virtualbox/private_key
  ForwardAgent yes
```
- deploy the code: https://gist.github.com/johnnaegle/f14dbd5a556018c035fb
```
bundle exec cap vagrant deploy
```
- Make sure the site is running:
```
http://www.sprockets-master
```

## Reproduce the issue

- Make a trivial change to jquery.balloon.js.erb.  Change the ```var fred='flintstone';``` line.  Commit and push.
- Deploy the code
- ssh into the vagrant host and inspect the assets:
```
ssh vagrant@sprockets-master
cd public/assets/
grep fred jquery.balloon-*.js | cut -c 1-50
```
- you should the line you changed
- check application.js
```
grep fred application-*.js | cut -c 1-50
```
- you'll see the original line ```fred='flintstone'```

## Fix the issue

- upgrade sprockets to 3.4.0
- perform a deploy
- make the same trivial change
- perform a second deploy
- observe the trivial chagne is included in the manifest file

# Cleanup

- Nule the virtual machine: ```vagrant destroy```
- Remove ~/.ssh/known_hosts entry for 192.168.50.8
