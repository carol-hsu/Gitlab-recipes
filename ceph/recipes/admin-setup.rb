bash 'admin-preflight-setup' do
    user 'root'
    code <<-EOH
		wget -q -O- 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' | sudo apt-key add -
		echo deb http://ceph.com/debian-firefly/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
		sudo apt-get update -y && sudo apt-get install ceph-deploy -y
    EOH
end

user 'cepher' do
    home '/home/cepher'
    shell '/bin/bash'
    password '$1$gbabLqW/$ELv1pY2Vl86jVDm8gXS/b1'
    action :create
    notifies :run 'execute[create-sshkey]', :immediately
end

execute 'create-sshkey' do
	user 'cepher'
	command "ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''"
	action :nothing
	notifies :run 'bash[enable-passwdless-ssh]', :immediately
end

