#encoding=utf-8
import yaml
import os
import configparser
import commands
import sys
sys.getdefaultencoding()

#config_path="/root/test/config.ini"
pwd=os.getcwd()
config_path=pwd+'/config.ini'
tmp_dir=pwd+'/template'

def get_config(key):
    conf= configparser.ConfigParser()
    conf.read(config_path)
    value=conf.get('wordpress',key)
    return value
    
class kube_yaml:
    def __init__(self):
        tmp_dir=pwd+'/template'
    
    def init(self,namespace):
	dir_name=pwd+'/'+get_config('namespace')
        try:
            os.mkdir(dir_name)
        except:
            pass

    def set_namespace(self,namespace):
        conf_namespace=open(tmp_dir+'/wp-namespace.yaml','r+')
        conf_yaml=yaml.load(conf_namespace,Loader=yaml.FullLoader)
        conf_yaml['metadata']['name']=namespace
        #file_name=eval(namespace)+'-namespace.yaml'
	file_name='wp-namespace.yaml'
        file_path=wp_dir+'/'+file_name
        f=open(file_path,'w')
        try:
            yaml.dump(conf_yaml,f,encoding='utf-8')
 	    f.close()
            print "Namespace "+namespace+" create: OK"
        except Exception,e:
	    f.close()
	    print "Namespace "+namespace+" create fail:"+str(e)

    def set_rbd_storage(self,namespace):
     	conf_namespace=open(tmp_dir+'/rbd-storage.yaml','r+')
        conf_yaml=yaml.load(conf_namespace,Loader=yaml.FullLoader)
        conf_yaml['metadata']['namespace']=namespace
        file_name='rbd-storage.yaml'
  	file_path=wp_dir+'/'+file_name
        f=open(file_path,'w')
        try:
            yaml.dump(conf_yaml,f)
            f.close()
            print "Storage "+file_name+" create: OK"
        except Exception,e:
            f.close()
            print "Storage "+file_name+" create fail:"+str(e)
       
    
    def set_pvc(self,namespace):
        conf_namespace=open(tmp_dir+'/wp-pvc.yaml','r+')
        conf_yaml=yaml.load(conf_namespace,Loader=yaml.FullLoader)
        conf_yaml['metadata']['namespace']=namespace
        file_name='wp-pvc.yaml'
        file_path=wp_dir+'/'+file_name
        f=open(file_path,'w')
        try:
            yaml.dump(conf_yaml,f)
            f.close()
            print "Pvc "+file_name+" create: OK"
        except Exception,e:
            f.close()
            print "Pvc "+file_name+" create fail:"+str(e)

    def set_secret(self,namespace,mysql_root_password,wordpress_password):
	conf_secret=open(tmp_dir+'/wp-secret.yaml','r+')
        conf_yaml=yaml.load(conf_secret,Loader=yaml.FullLoader)
	cmd_mysql_root_password="echo "+mysql_root_password+" | base64"
  	mysql_root_password=commands.getoutput(cmd_mysql_root_password)
	cmd_wordpress_password="echo "+wordpress_password+" | base64"
	wordpress_password=commands.getoutput(cmd_wordpress_password)
        conf_yaml['data']['mysql_root_password']=mysql_root_password
	conf_yaml['data']['wordpress_password']=wordpress_password
	conf_yaml['metadata']['namespace']=namespace
        file_name='wp-secret.yaml'
        file_path=wp_dir+'/'+file_name
        f=open(file_path,'w')
        try:
            yaml.dump(conf_yaml,f)
            f.close()
            print "Secret "+file_name+" create: OK"
        except Exception,e:
            f.close()
            print "Secret "+file_name+" create fail:"+str(e)


    def set_deployment_false(self,namespace):
	conf_deployment=open(tmp_dir+'/wp-deployment.yaml','r+')
        conf_yaml=yaml.load(conf_deployment,Loader=yaml.FullLoader)
	conf_yaml['metadata']['name']=namespace
        conf_yaml['metadata']['namespace']=namespace
        conf_yaml['spec']['template']['metadata']['labels']['app']=namespace
	#conf_yaml['spec']['template']['spec']['containers']['']['']=
        file_path=wp_dir+'/'+file_name
        f=open(file_path,'w')
        try:
            yaml.dump(conf_yaml,f)
            f.close()
            print "Deployment "+file_name+" create: OK"
        except Exception,e:
            f.close()
            print "Deployemnt "+file_name+" create fail:"+str(e)

    def set_deployment(self,namespace):
	path=tmp_dir+'/wp-deployment.yaml'
	cmd="cp "+path+" "+wp_dir
 	commands.getoutput(cmd)
	cmd_sed="sed -i 's/ns-wordpress/"+namespace+"/g'"+" "+wp_dir+"/wp-deployment.yaml"
	commands.getoutput(cmd_sed)
	print "Deployment "+namespace+" create: OK"
    
    def set_service(self,namespace,service_port):
        service_port=int(service_port)
        conf_service=open(tmp_dir+'/wp-service.yaml','r+')
        conf_yaml=yaml.load(conf_service,Loader=yaml.FullLoader)
        conf_yaml['metadata']['namespace']=namespace
	conf_yaml['spec']['ports'][0]['nodePort']=service_port
	conf_yaml['spec']['selector']['app']=namespace
        file_name='wp-service.yaml'
        file_path=wp_dir+'/'+file_name
        f=open(file_path,'w')
        try:
            yaml.dump(conf_yaml,f)
            f.close()
            print "Service "+file_name+" create OK"
        except Exception,e:
            f.close()
            print "Service "+file_name+" create fail:"+str(e)

    
    def set_configmap(self):
	cm_path=tmp_dir+'/wp-config.php'
	cmd="cp "+cm_path+" "+wp_dir
	try:
	    commands.getoutput(cmd)
  	except Exception,e:
	    print str(e)

    def init_kube(self,namespace):
        ns="kubectl create -f "+wp_dir+"/wp-namespace.yaml"
	cm="kubectl create configmap cm-wordpress --from-file="+wp_dir+"/wp-config.php -n "+namespace
	secret="kubectl create -f "+wp_dir+"/wp-secret.yaml"
	storage="kubectl create -f "+wp_dir+"/rbd-storage.yaml"
	pvc="kubectl create -f "+wp_dir+"/wp-pvc.yaml"
	deployment="kubectl create -f "+wp_dir+"/wp-deployment.yaml"
	service="kubectl create -f "+wp_dir+"/wp-service.yaml"
	list=[ns,cm,secret,storage,pvc,deployment,service]
	for i in list:
	    commands.getoutput(i)

def main():
    namespace=get_config('namespace')
    mysql_root_password=get_config('mysql_root_password')
    wordpress_user=get_config('wordpress_user')
    wordpress_password=get_config('wordpress_password')
    service_port=get_config('service_port')
    #print namespace
    yml=kube_yaml()
    yml.init(namespace)
    global wp_dir
    wp_dir=pwd+'/'+namespace
    #print wp_dir
    yml.set_namespace(namespace)
    yml.set_rbd_storage(namespace)
    yml.set_pvc(namespace)
    #yml.set_deployment(self,namespace,mysql_root_password,wordpress_user,wordpress_password)
    yml.set_secret(namespace,mysql_root_password,wordpress_password)
    yml.set_deployment(namespace)
    yml.set_service(namespace,service_port)
    yml.set_configmap()
    yml.init_kube(namespace)


if __name__ == "__main__":
    main()

