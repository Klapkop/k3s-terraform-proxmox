[master]
${k3s_server_ip}

[node]
${k3s_node_ip}

[k3s_cluster:children]
master
node