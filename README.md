# vmAzure
Maquina Virtual Azure levantada con terraform

En caso de no poder hacer el az login , se debe autorizar es dispositivo de estas forma az login --use-device-code
esto nos entregara el codigo de dispositivo que debemos ingresar en el portal de azure para poder hacer el login.

Crear un Service Principal (SP) para Terraform

az ad sp create-for-rbac --name "terraform-sp" --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"


cambiar a permisos chmod 400 las .pem 

forma de conexión 



la llave debe estar alojada en el directorio .ssh de nuestra maquina local

al generar por terraform , se deben restablecer las llaves para poder por azure , darle el nombre que necesitemos , por la conexión de ssh nativo, realice la prueba generando llaves directamente de ubuntu , pero no las toma , por lo que se debe generar la llave en la maquina virtual de azure y luego descargar y con debemos conectarnos de la siguiente forma 

ssh -i ~/.ssh/maqAzure3.pem azureuser@172.174.94.43 ( la ip cambia cada vez que se levanta la maquina virtual, considerar este dato).

tambien la .pem al generarse cada vez que levantemos la maquina desde 0 , debemos moverla al .ssh de nuestra maquina local y cambiar con chmod 400 