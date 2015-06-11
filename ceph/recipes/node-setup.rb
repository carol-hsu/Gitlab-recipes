apt_package 'ntp' do
	action :install
end

apt_package 'openssh-server' do
    action :install
end

user 'cepher' do
	home '/home/cepher'
	shell '/bin/bash'
	password '$1$gbabLqW/$ELv1pY2Vl86jVDm8gXS/b1'
	action :create
	notifies :run 'bash[make-cepher-a-sudoer]', :immediately
end

bash 'make-cepher-a-sudoer' do
    user 'root'
    code <<-EOH
	echo "cepher ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/cepher
	sudo chmod 0440 /etc/sudoers.d/cepher
    EOH
	action :nothing
end


