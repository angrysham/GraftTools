#!/bin/bash

case $1 in
	provision)
 		cd sandbox1 && terraform init && terraform plan && terraform apply -auto-aprove
	;;
	reprovision)
 		cd sandbox1 && terraform init && terraform plan && terraform apply 
	;;
	deploy)
		cd ansible && source env_vars.sh
		./update_ssh_config.sh
	        echo "Installing Python2..."       
		ansible-playbook -i ./ec2.py common.yml
	        echo "Deploying graftnode package to Role: cryptonode hosts..."       
		ansible-playbook -i ./ec2.py deploy-cryptonode.yml
	        echo "Deploying graftnode package to Role: supernode hosts..."       
		ansible-playbook -i ./ec2.py deploy-supernode.yml
	;;
	redeploy)
		cd ansible && source env.sh && ansible-playbook -i ./ec2.py common.yml
	;;
	destroy)
		cd sandbox1 && terraform destroy -auto-aprove
	;;
	ping)
		cd ansible && source env.sh 
		ansible -i ec2.py us-east-1a -m ping
	;;
	status) 
		cd ansible && source env_vars.sh
		ansible-playbook -i ./ec2.py service.yml
	;;
	*)
		echo  "Usage: $0 provision |  reprovision | deploy | redeploy | destroy | status"
		
	;;
esac
