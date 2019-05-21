#!/bin/bash

if [ -x "$(command -v jq)" ]; then
	  echo 'jq has been found'
else
	  echo 'Error: jq is not installed. Please install jq binary...'
	  exit 1
fi

case $1 in
	provision)
 		cd sandbox1 && terraform init && terraform plan && terraform apply -auto-approve
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
		cd ansible && source env_vars.sh 
	        echo "Installing Python2..."       
		ansible-playbook -i ./ec2.py common.yml
	        echo "Deploying graftnode package to Role: cryptonode hosts..."       
		ansible-playbook -i ./ec2.py deploy-cryptonode.yml
	        echo "Deploying graftnode package to Role: supernode hosts..."       
		ansible-playbook -i ./ec2.py deploy-supernode.yml

	;;
	destroy)
		cd sandbox1 && terraform destroy
	;;
	ping)
		cd ansible && source env_vars.sh 
		ansible -i ./ec2.py us-east-1a -m ping
	;;
        command)
		cd ansible && source env_vars.sh 
		ansible -i ./ec2.py us-east-1 -m command -a $2

	;;
	status) 
		cd ansible && source env_vars.sh
		ansible-playbook -i ./ec2.py service.yml
	;;
	*)
		echo  "Usage: $0 provision |  reprovision | deploy | redeploy | destroy | status"
		echo -e "Usage $0 [32mprovision[0m|[32mreprovision[0m| \n\t provison -- create Infrustrusture for graft network\n\t reprovision -- update infrastrucure after changes made to project files"
		echo -e "Usage $0 [32mdeploy[0m|[32mredeploy[0m| status |[31m destroy[0m \n\t deploy -- install graftnode and/or graft-supernode packages depending on ec2_Tag \n\t redeploy -- reinstall\\upgrade graftnode and/or graft-supernode packages depending on ec2_Tag\n\t destroy -- destroy infrastrucure by terminating EC2 instances and resources used by sandbox environment"
		
	;;
esac
