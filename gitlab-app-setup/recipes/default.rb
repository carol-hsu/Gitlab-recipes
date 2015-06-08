#install package
package [ 'curl', 'openssh-server', 'ca-certificates', 'postfix' ] 

#get source code
execute 'download deb' do
    command 'curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash'
end

#install
apt_package 'gitlab-ce' do
    action :install
end

#change to ELB DNS Name
#execute 'change url' do
#	command 'sed /etc/gitlab/gitlab.rb'
#end

#start gitlab
execute 'start gitlab' do
	command 'gitlab-ctl reconfigure | gitlab-ctl start'
end
