#!/bin/bash

case $1 in
	provision)
 		cd sandbox1 && terraform init && terraform plan && terraform apply -auto-aprove
	;;
	reprovision)
 		cd sandbox1 && terraform init && terraform plan && terraform apply 
	;;
	deploy)
		cd ansible && source env.sh 
	        echo "Installing Python2..."       
		ansible-playbook -i ./ec2.py common.yml
	        echo "Deploying graftnode package to  Role: cryptonode hosts..."       
		ansible-playbook -i ./ec2.py deploy_cryptonode.yml
	        echo "Deploying graftnode package to  Role: supernode hosts..."       
		ansible-playbook -i ./ec2.py deploy_supernode.yml
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
	*)
		echo  "Usage: $0 provision |  reprovision | deploy | redeploy | destroy"
		
	;;
esac
