#B1:Tạo một EC2 chạy Ubuntu
#B2:cấp cho Kops instance (máy ảo EC2 tạo ở trên) quyền iam role có policy: AdministratorAccess. (để có thể tương tác với các dịch vụ khác của aws)
#B3:Tạo một S3 bucket để lưu trữ state của Kops
#Cài đặt AWS CLI:
sudo apt update

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

sudo apt install unzip

unzip awscliv2.zip

sudo ./aws/install

aws --version


#==============Cài đặt Kubectl & Kops cho server.==================================

#Cài đặt Kubectl
#Tham khảo link sau:
#https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl

kubectl help

#Cài đặt Kops
#Tham khảo link sau: https://kops.sigs.k8s.io/getting_started/install/
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64

chmod +x kops

sudo mv kops /usr/local/bin/kops

kops version



#Chuẩn bị domain
#Kiểm tra domain:

nslookup -type=ns haudt.click

#Tạo cluster = KOPS command

kops create cluster \
    --name haudt.click \
    --state=s3://kops-state-bucket-01 \
    --zones=us-east-1a,us-east-1b \
    --node-count=2 --node-size=t3.medium \
    --master-size=t3.medium --dns-zone haudt.click \
    --node-volume-size=10 --master-volume-size=10


#Apply để tạo cluster:
kops update cluster --name haudt.click --state=s3://kops-state-bucket-01 --yes --admin

#upgrade cluster:
kops upgrade cluster --name haudt.click --state=s3://kops-state-bucket-01 --yes

#Validate cluster:(quá trình validate mất 7-10p)
kops validate cluster --name haudt.click --state=s3://kops-state-bucket-01 --wait 10m

#getnode: kiểm tra trạng thái các node của cluster
kubectl get nodes

#output as below is OK(example)
NODE STATUS
NAME                    ROLE            READY
i-03ee28b8c4c2fd0cb     node            True
i-04b3c3d35f590fc60     control-plane   True
i-0cdc0ec740ecf6504     node            True


#Kiểm tra thông tin cluster:
kubectl cluster-info
kubectl get nodes


