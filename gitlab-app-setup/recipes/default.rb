#install package
%w{ curl openssh-server ca-certificates postfix }.each do |pkg|
	package pkg 
end
#package [ 'curl', 'openssh-server', 'ca-certificates', 'postfix' ] 

#get source code
execute 'download deb' do
#    command 'curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash'
	command 'curl -s https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash'
end

#install
apt_package 'gitlab-ee' do
    action :install
end

#change to ELB DNS Name
#execute 'change url' do
#	command 'sed -i "4c exeternal_url \''+node[:elb_dns]+'\'" /etc/gitlab/gitlab.rb'
#end

template "/etc/gitlab/custom-gitlab.rb" do
	source "custom-gitlab.rb.erb"
	mode '600'
	owner 'root'
	group 'root'
	variables ({
		:redis_endpoint => node[:cache_endpoint],
		:db_name =>	node[:database][:name],
		:db_user => node[:database][:user],
		:db_passwd => node[:database][:password],
		:db_endpoint => node[:database][:endpoint]
	})	
	notifies :run, 'execute[change-configure-rb]', :immediately
end

execute 'change-configure-rb' do
	cwd '/etc/gitlab'
	command 'cat custom-gitlab.rb >> gitlab.rb'
	action :nothing
end

##start gitlab
#execute 'start gitlab' do
#	command 'gitlab-ctl start && gitlab-ctl reconfigure'
#end
