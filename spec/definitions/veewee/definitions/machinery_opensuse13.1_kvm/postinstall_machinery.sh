#!/bin/bash
# Add 13.1 repositories as they can not be added via
# autoyast due to some bug.
zypper --gpg-auto-import-keys ar --refresh --name "Main Repository (OSS)" http://download.opensuse.org/distribution/13.1/repo/oss/ download.opensuse.org-oss
zypper --gpg-auto-import-keys ar --refresh --name "Main Repository (NON-OSS)" http://download.opensuse.org/distribution/13.1/repo/non-oss/ download.opensuse.org-non-oss

zypper --gpg-auto-import-keys ar --refresh --name "Main Update Repository" http://download.opensuse.org/update/13.1/ download.opensuse.org-update
zypper --gpg-auto-import-keys ar --refresh --name "Update Repository (Non-Oss)" http://download.opensuse.org/update/13.1-non-oss/ download.opensuse.org-13.1-non-oss

zypper --gpg-auto-import-keys ar --disable --refresh --name "openSUSE-13.1-Debug" http://download.opensuse.org/debug/distribution/13.1/repo/oss/ repo-debug
zypper --gpg-auto-import-keys ar --disable --refresh --name "openSUSE-13.1-Update-Debug" http://download.opensuse.org/debug/update/13.1/ repo-debug-update
zypper --gpg-auto-import-keys ar --disable --refresh --name "openSUSE-13.1-Update-Debug-Non-Oss" http://download.opensuse.org/debug/update/13.1-non-oss/ repo-debug-update-non-oss

zypper --gpg-auto-import-keys ar --disable --refresh --name "openSUSE-13.1-Source" http://download.opensuse.org/source/distribution/13.1/repo/oss/ repo-source

zypper --non-interactive up

# Install git for checking out the machinery code and other machinery dependencies
zypper --non-interactive install --no-recommends git libxslt1 libxslt-devel zlib-devel libxml2-devel libvirt-devel expect patch

# Install kiwi and dependencies for building
zypper --non-interactive install --no-recommends kiwi kiwi-desc-vmxboot kiwi-tools db45-utils db-utils grub

# Install bundler, rspec and the junit formatter (for jenkins)
gem install bundler rspec rspec_junit_formatter

# Generate a SSH identity
su vagrant -c "mkdir -p /home/vagrant/.ssh; echo -e  'y\n'|ssh-keygen -q -t rsa -N '' -f /home/vagrant/.ssh/id_rsa"

# checkout and setup machinery and pennyworth
su vagrant -c "cd && git clone https://github.com/SUSE/machinery.git"
su vagrant -c "cd && git clone https://github.com/SUSE/pennyworth.git"

cd /home/vagrant/machinery && bundle config build.nokogiri --use-system-libraries && bundle install
cd /home/vagrant/pennyworth && bundle config build.nokogiri --use-system-libraries && bundle install

# Make sure that everything's written to disk, otherwise we sometimes get
# empty files in the image
sync