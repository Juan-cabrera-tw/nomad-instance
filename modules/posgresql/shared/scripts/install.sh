VAULT_EXTERNAL_ADDR=$(cat /tmp/vault-private-addr| tr -d '\n')
echo "installing vault helper"
wget https://releases.hashicorp.com/vault-ssh-helper/0.2.1/vault-ssh-helper_0.2.1_linux_amd64.zip
sudo unzip -q vault-ssh-helper_0.2.1_linux_amd64.zip -d /usr/local/bin
sudo chmod 0755 /usr/local/bin/vault-ssh-helper
sudo chown root:root /usr/local/bin/vault-ssh-helper
sudo mkdir /etc/vault-ssh-helper.d/

echo "setting vault helper"
sudo tee /etc/vault-ssh-helper.d/config.hcl <<EOF
vault_addr = "$VAULT_EXTERNAL_ADDR"
tls_skip_verify = false
ssh_mount_point = "ssh"
allowed_roles = "*"
EOF

# usage with SELinux
sudo cp /etc/pam.d/sshd /etc/pam.d/sshd.orig
sudo sed -i 's/#%PAM-1.0/#%PAM-1.0\nauth requisite pam_exec.so quiet expose_authtok log=\/var\/log\/vault-ssh.log \/usr\/local\/bin\/vault-ssh-helper -dev -config=\/etc\/vault-ssh-helper.d\/config.hcl\nauth optional pam_unix.so not_set_pass use_first_pass nodelay/' /etc/pam.d/sshd
sudo sed -i '/^auth       substack     password-auth$/s/^/# /' /etc/pam.d/sshd
sudo sed -i '/^password   include      password-auth$/s/^/# /' /etc/pam.d/sshd

sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.orig
sudo perl -i -pe 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
sudo perl -i -pe 's/UsePAM no/UsePAM yes/g' /etc/ssh/sshd_config
sudo perl -i -pe 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

echo 'restarting sshd'
sudo systemctl restart sshd
echo $(vault-ssh-helper -verify-only -dev -config /etc/vault-ssh-helper.d/config.hcl)
