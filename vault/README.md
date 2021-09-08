# Deploy Vault 

### Requirements

 * Terraform
 * Ansible (brew install ansible)
 * SSH KEYS PEM AND PUB 
  ```
   $ ssh-keygen -t rsa -m PEM
```

### Execution
- Run in your local machine
 ```sh
   $ sh deploy.sh
```

### Access URL
 * http://your_ip:8200
 * login with your root key
### Destroy
 * Run in your local machine
 ```sh
   $ sh destroy.sh
```

