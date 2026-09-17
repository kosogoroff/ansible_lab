# Выполненное ДЗ "Занятие 24.08.2026 "Автоматизация администрирования. Ansible"

В проекте реализовано создание и конфигурация nginx для двух гипервизиров (virtualbox или libvirt/kvm) в зависимости от семейства Linux (Debian или RedHat).

При создании и конфигурировании виртуальных машин возможны следующие варианты запуска:

1) Для создания ВМ в гипервизоре virtualbox с использованием бокса generic/ubuntu2204 на vagrantcloud нужно запустить командой

```
vagrant up
```

Если боксы установлены на компьютере локально, например:

```
[admin_insta11@mv334 network-storage-provisioning]$ vagrant box list
almalinux9-stand        (libvirt, 0)
almalinux9-stand-vb     (virtualbox, 0)
ubuntu-22.04-virtualbox (virtualbox, 0)
[admin_insta11@mv334 network-storage-provisioning]$ 
```

2) Для создания ВМ в гипервизоре libvirt/kvm с использованием локально установленного бокса almalinux/9 нужно запустить командой (в данной лабораторной нам вариант с Almalinux не нужен, приведён справочно)

```
VAGRANT_BOX=almalinux9-stand VAGRANT_DEFAULT_PROVIDER=libvirt vagrant up --provider=libvirt
```

3) Для создания ВМ в гипервизоре virtualbox с использованием локально установленного бокса almalinux/9 нужно запустить командой

```
VAGRANT_BOX=almalinux9-stand-vb vagrant up --provider=virtualbox
```

или

```
VAGRANT_BOX=almalinux9-stand-vb vagrant up
```

**Примечание:** если на хосте установлено два гипервизора libvirt/kvm и virtualbox одновременно, то для запуска виртуальных машин в гипервизоре virtualbox необходимо сначала остановить все виртуальные машины, запущенные в гипервизоре libvirt/kvm, остановить гипервизор libvirt/kvm и выгрузить драйвера ядра гипервизор libvirt/kvm:

```
[admin_insta11@mv334 ansible_lab]$ sudo bash -c 'for vm in $(virsh list --name); do virsh shutdown "$vm"; done'
Domain 'ubuntu-24.04-01' is being shutdown

[admin_insta11@mv334 ansible_lab]$
[admin_insta11@mv334 ansible_lab]$ sudo systemctl stop libvirtd.socket libvirtd-ro.socket libvirtd-admin.socket libvirtd.service
[sudo] пароль для admin_insta11: 
[admin_insta11@mv334 ansible_lab]$ 
[admin_insta11@mv334 ansible_lab]$ sudo modprobe -r kvm_intel
[admin_insta11@mv334 ansible_lab]$ 
```

Для запуска виртуальных машин в гипервизоре libvirt/kvm необходимо остановить все запущенные в гипервизоре virtualbox виртуальные машины (сервис и драйвера virtualbox останавливать не нужно), загрузить драйвера ядра и запустить сервис libvrt:

```
[admin_insta11@mv334 ansible_lab]$ sudo modprobe kvm_intel
[admin_insta11@mv334 ansible_lab]$
[admin_insta11@mv334 ansible_lab]$ sudo systemctl start libvirtd.service
[admin_insta11@mv334 ansible_lab]$
```

При создании проекта использовались следующие команды:
···
[admin_insta11@mv334 ansible_lab]$ ls -al
итого 32
drwxrwxr-x   4 admin_insta11 admin_insta11 4096 сен 17 19:36 .
drwx------. 29 admin_insta11 admin_insta11 4096 сен 17 18:46 ..
-rw-rw-r--   1 admin_insta11 admin_insta11  113 сен 15 19:08 ansible.cfg
-rwxrwxr-x   1 admin_insta11 admin_insta11  733 сен 17 14:46 gen_ansible_inventory.sh
-rw-rw-r--   1 admin_insta11 admin_insta11 2112 сен 17 18:09 nginx.yml
drwxrwxr-x   2 admin_insta11 admin_insta11 4096 сен 15 19:09 staging
drwxrwxr-x   2 admin_insta11 admin_insta11 4096 сен 15 19:25 templates
-rw-rw-r--   1 admin_insta11 admin_insta11 2737 сен 17 18:24 Vagrantfile
[admin_insta11@mv334 ansible_lab]$ git init
hint: Using 'master' as the name for the initial branch. This default branch name
hint: will change to "main" in Git 3.0. To configure the initial branch name
hint: to use in all of your new repositories, which will suppress this warning,
hint: call:
hint:
hint: 	git config --global init.defaultBranch <name>
hint:
hint: Names commonly chosen instead of 'master' are 'main', 'trunk' and
hint: 'development'. The just-created branch can be renamed via this command:
hint:
hint: 	git branch -m <name>
hint:
hint: Disable this message with "git config set advice.defaultBranchName false"
Инициализирован пустой репозиторий Git в /home/admin_insta11/ansible_lab/.git/
[admin_insta11@mv334 ansible_lab]$ 
[admin_insta11@mv334 ansible_lab]$ git remote add origin https://github.com/kosogoroff/ansible_lab.git
[admin_insta11@mv334 ansible_lab]$ git add .
[admin_insta11@mv334 ansible_lab]$ git status
Текущая ветка: master

Еще нет коммитов

Изменения, которые будут включены в коммит:
  (используйте «git rm --cached <файл>...», чтобы убрать из индекса)
	новый файл:    Vagrantfile
	новый файл:    ansible.cfg
	новый файл:    gen_ansible_inventory.sh
	новый файл:    nginx.yml
	новый файл:    staging/hosts
	новый файл:    templates/nginx.conf.j2

[admin_insta11@mv334 ansible_lab]$ git branch -M main
[admin_insta11@mv334 ansible_lab]$ git commit -m ""
Display all 457 possibilities? (y or n)
[admin_insta11@mv334 ansible_lab]$ git commit -m "ДЗ Автоматизация Ansible"
[main (корневой коммит) bd71179] ДЗ Автоматизация Ansible
 6 files changed, 215 insertions(+)
 create mode 100644 Vagrantfile
 create mode 100644 ansible.cfg
 create mode 100755 gen_ansible_inventory.sh
 create mode 100644 nginx.yml
 create mode 100644 staging/hosts
 create mode 100644 templates/nginx.conf.j2
[admin_insta11@mv334 ansible_lab]$ git push -u origin main
Перечисление объектов: 10, готово.
Подсчет объектов: 100% (10/10), готово.
При сжатии изменений используется до 4 потоков
Сжатие объектов: 100% (8/8), готово.
Запись объектов: 100% (10/10), 3.28 KiB | 372.00 KiB/s, готово.
Total 10 (delta 0), reused 0 (delta 0), pack-reused 0 (from 0)
To https://github.com/kosogoroff/ansible_lab.git
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
[admin_insta11@mv334 ansible_lab]$
```
