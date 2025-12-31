# 1. Update system and install prerequisites
sudo yum update -y
sudo yum install wget -y
sudo yum install java-17-amazon-corretto -y

# 2. Create application directory
sudo mkdir /app
cd /app

# 3. Download and extract Nexus
sudo wget https://download.sonatype.com/nexus/3/nexus-3.79.1-04-linux-x86_64.tar.gz
sudo tar -xvf nexus-3.79.1-04-linux-x86_64.tar.gz

# 4. Rename and organize directories
sudo mv nexus-3.79.1-04 nexus

# 5. Create nexus user
sudo adduser nexus

# 6. Set permissions correctly
sudo chown -R nexus:nexus /app/nexus

# 7. Fix the sed command - correct format
sudo sed -i '27s/.*/run_as_user="nexus"/' /app/nexus/bin/nexus

# 8. Create data directory
sudo mkdir -p /app/sonatype-work
sudo chown -R nexus:nexus /app/sonatype-work

# 9. Create corrected systemd service file
sudo tee /etc/systemd/system/nexus.service > /dev/null << 'EOL'
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/app/nexus/bin/nexus start
ExecStop=/app/nexus/bin/nexus stop
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOL

# 10. Reload systemd and enable service
sudo systemctl daemon-reload
sudo systemctl enable nexus

# 11. Start Nexus service
sudo systemctl start nexus

# 12. Check status
sudo systemctl status nexus

# 13. Wait a moment and check if it's running
sleep 5
sudo systemctl status nexus
