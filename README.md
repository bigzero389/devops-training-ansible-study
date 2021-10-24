# 앤서블 철저 입문 Training
* 2021.10.23(토) 광진정보도서관.

## Chaper 01


## Chapter 02 - ansible-tutorial
* 리눅스 계열에서만 ansible 이 설치된다.
* python3 를 기본 python 으로 셋팅했다.
* Vagrant 와 VirtualBox 사용하지 않고 EC2를 직접 사용한다.

### Inventory
```
[ec2]
3.35.50.79

[ec2:vars]
ansible_ssh_private_key_file=~/.ssh/dyheo-histech.pem
```
### ansible.cfg
* ANSIBLE_CONFIG 환경변수에서 지정한 파일
* 현재 디렉터리에 있는 ansible.cfg 파일
* 사용자 홈 디렉터리 아래의 .ansible.cfg 파일. (숨김파일임)
* /etc/ansible/ansible.cfg 파일(글로벌 기본설정)
* 위의 4가지가 위에서 부터의 우선순위로 적용된다.
```
[defaults]
inventory = $PWD/inventory
remote_user = ec2-user
ask_pass = false
host_key_checking = false

[privileage_escalation]
become = true
become_method = sudo
become_user = root
become_ask_pass = false
```

### Command Example
```
ansible all -i inventory -m ping # 보안그룹에 ICMP 를 허용해야 한다.
ansible all -i inventory -m setup
ansible --private-key=~/.ssh/dyheo-histech.pem -i inventory ./site.yml 
ansible-inventory -i inventory_aws_ec2.yml --graph
```

## Chapter 03 - ansible-detail
### Dynamic Inventory
```
ansible-inventory -i inventory_aws_ec2.yml --graph # grouping 확인
ansible-playbook -i inventory_aws_ec2.yml site.yml # 동적그룹핑에 의한 일괄작업
```

