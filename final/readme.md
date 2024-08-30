ПОРЯДОК


sprint_1

	1. Выбираем облачный провайдер и инфраструктуру

	в файл variables.tf в папке внести свои
	token
	cloud_id
	folder_id

	применит конфигурацию:
	terraforn apply

	2. Разворачиваем K8s

	скачать kubespray
	git clone https://github.com/kubernetes-sigs/kubespray.git
	cd kubespray

	поправить файл inventory.ini на свои значения, пример
	----
	[all]
	k8s-master ansible_host=84.201.129.186 ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
	k8s-node ansible_host=51.250.68.34 ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa

	[kube_control_plane]
	k8s-master

	[kube_node]
	k8s-node

	[etcd]
	k8s-master

	[k8s_cluster:children]
	kube_control_plane
	kube_node

	----
	
	3. Устанавливаем K8s
	ansible-playbook -i inventory/mycluster/inventory.ini --become --become-user=root cluster.yml



sprint_2

	1. Cоздать копию репозитория с приложением

	Пример: https://github.com/git-volk/django-pg-docker-tutorial

	2. Переместить на сервер с k8s-master папку c описанием хелм чарта по установке приложения my_app_chart в директорию /tmp

	3. Развернуть дженкинс на сервере srv

	docker run --name jenkins -d -p 8080:8080 jenkins/jenkins:lts

	4. Настроить веб-хук с гитхаба на jenkins на сервере srv

	по коммиту в гит с тегом "2.0.3" собирается докер-образ приложения с название "testapp:2.0.3" и загружается в докер-хаб hub.docker.com/skillfactory/testapp:2.0.3
	в дженкинс пайплайне после сборки приложения будет деплой в K8s через хелм чарт
	см. Jenkinsfile



sprint_3

	1. установить на сервер SRV:

	prometheus
	node exporter
	blackbox exporter

	ansible-galaxy collection install prometheus.prometheus
	ansible-playbook -i inventori.ini playbook.yml

	2. установить на сервер SRV grafana
	sudo docker run -d --name=grafana -p 3000:3000 grafana/grafana:11.2.0

	3. Конфиг для настройки blackbox_exporter - blackbox_exporter.yaml
	
	4. Конфиг для подключения экспортеров к prometheus - prometheus.yaml

	5. Настраиваем в графана дашборды для srv
	
	6. Настраиваем в графана дашборды для srv
