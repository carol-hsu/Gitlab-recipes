mon1 = node[:opsworks][:layers]['ceph-mon'][:instances]['ceph-mon1'][:private_ip]
osd1 = node[:opsworks][:layers]['ceph-osd'][:instances]['ceph-osd1'][:private_ip]
osd2 = node[:opsworks][:layers]['ceph-osd'][:instances]['ceph-osd2'][:private_ip]

bash 'enable-passwdless-ssh' do
    user 'cepher'
    code <<-EOH
	ssh-copy-id cepher@#{mon1}
	ssh-copy-id cepher@#{osd1}
	ssh-copy-id cepher@#{osd2}
    EOH
end

#create a cluster
execute 'create-cluster' do
	command "ceph-deploy new #{mod1}"
end

