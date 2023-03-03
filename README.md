# IaC-Lab01
Laboratório - 25-02-2022

- Criar um módulo terraform que crie em multi regiões (2) os seguintes recursos:
	- VPC
	- 3 Subnets (Uma em cada AZ)
	- Internet Gateway
	- 2 Maquinas EC2  
	- 1 Banco de dados RDS PostgreSQL
	- 1 Balanceador de Carga
	- Security Group para cada recurso acima (EC2, RDS e Balanceador)


```
terraform init
terraform validate
terraform plan
terraform apply
```

### VPC
#### eu-west-1
![](images/VPC-eu-west-1.png)
#### eu-west-2
![](images/VPC-eu-west-2.png)

### Subnets
#### eu-west-1a
![](images/Subnet-eu-west-1a.png)
#### eu-west-1b
![](images/Subnet-eu-west-1b.png)
#### eu-west-1c
![](images/Subnet-eu-west-1c.png)

#### eu-west-2a
![](images/Subnet-eu-west-2a.png)
#### eu-west-2b
![](images/Subnet-eu-west-2b.png)
#### eu-west-2c
![](images/Subnet-eu-west-2c.png)


### Internet Gateway
#### eu-west-1
![](images/InternetGateway-eu-west-1.png)
#### eu-west-2
![](images/InternetGateway-eu-west-2.png)

### EC2
#### eu-west-1
![](images/EC2-eu-west-1.png)
#### eu-west-2
![](images/EC2-eu-west-1.png)

### RDS
#### eu-west-1
![](images/RDS-eu-west-1.png)
![](images/RDS-eu-west-1-details.png)
#### eu-west-2
![](images/RDS-eu-west-2.png)
![](images/RDS-eu-west-2-details.png)

### Load Balancer
#### eu-west-1
![](images/LoadBalancer-eu-west-1.png)
#### eu-west-2
![](images/LoadBalancer-eu-west-2.png)

### Security Groups
#### eu-west-1
![](images/SecurityGroup-eu-west-1.png)
#### eu-west-2
![](images/SecurityGroup-eu-west-2.png)