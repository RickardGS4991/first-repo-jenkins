👨🏻‍🔧 Continuos Integration / Continuos Delivery

En este documento vamos a crear nuestra primera pipeline para replicar una integración continua. Para eso, usaremos una aplicación hecha con Java, un contenedor de Docker y Jenkins. El propósito de este repositorio es documentar el proceso uno por uno sobre la creación de pipeline (desde la creación del contenedor para el Jenkins Controller hasta la creación de la build con el pipeline). Comenzaremos con definiciones importantes:

1.- Integración Continua: La integración continua es el conjunto de etapas automatizadas que verifican cada cambio enviado desde un repo local a uno remoto. Es decir, una vez que el push ha sido enviado o se ha creado el Pull Request. La verificación se realiza mediante el proceso "Build", el cual si por algún error no logra finalizar, tanto jenkins como GitHub pueden avisarte.

2.- Artefacto: El artefacto es el resultado de un proceso build. Cuando la build finaliza, esta entrega un artefacto que permite ejecutar o desplegar la aplicación.

3.- Pipeline: Un pipeline es un conjunto de etapas automatizadas que definen el flujo de ejecución del proceso de build, incluyendo compilación, pruebas y validaciones. La Integración Continua representa el concepto teórico, mientras que la pipeline es la implementación práctica de dicho concepto mediante herramientas de automatización.

4.- Jenkins: Jenkins es una herramienta de automatización que permite crear y ejecutar pipelines para implementar procesos de Integración Continua (CI) y Entrega Continua (CD), orquestando builds, pruebas y validaciones de manera automatizada.

5.- Job: Un Job es la unidad de ejecución en Jenkins. En Jenkins moderno, una pipeline se ejecuta dentro de un Job, conocido como Pipeline Job, el cual contiene la definición del flujo de trabajo (Jenkinsfile), sus etapas y pasos.

6.- Controlador: El controlador es el encargado de orquestar a los agentes e indicarles QUÉ tienen que hacer.

7.- Agente: El agente es el encargado de realizar el Job de jenkins. Cada job vendrá definido en un jenkinsfile, el cuál indica cuál es el proceso de que debe seguir el pipeline para finalizar el job.

Instalación (MacOs) 🍎

Configuración del repositorio

Es necesario crear un repositorio en nuestro perfil de GitHub. Vamos a inicializar un repositorio en git en la carpeta donde se encuentra el proyecto que vamos usar. Para eso, usamos el comando "git init". Después, usamos el comando "git add ." (para guardar nuestros cambios en la rama actual), y usamos git commit -m "Primer commit" para confirmar esos cambios. Para enviar estos nuevos cambios a nuestra repositorio remoto (GitHub), primero debemos vincular el repositorio local con el repositorio remoto usando el comando: git remote add origin https://github.com/RickardGS4991/first-repo-jenkins. Este comando lo que hace es conectar la rama local con el repositorio remoto en GitHub.. Finalmente, para enviar los cambios al repo remoto usamos git push -u origin master. Si usamos -u, ya no es necesario que agreguemos origin master al comando "git push", porque git guardará la referencia. Esto lo podemos usar en cada rama nueva que creemos.

Configuración de Jenkins 🚧

El propósito de este repositorio es usar Docker con Jenkins. Por lo tanto, vamos a crear un Dockerfile, y lanzar nuestro contenedor. El Dockerfile ya lo tenemos listo en nuestro repositorio, así que ejecutaremos los siguientes comandos 
```bash
docker build -t jenkins-container .
docker run -d -p 8080:8080 -p 50000:50000 --name jenkins jenkins-container
```

Con esto, nuestro contenedor se creará, y jenkins quedará corriente. Ahora comenzaremos con la configuración inicial  de jenkins. 



Cuando Jenkins se ejecuta por primera vez, genera una clave de administrador para desbloquear la instalación. Esta clave podemos visualizarla en los logs, asi que ejecutamos el siguiente comando:
```bash
docker logs jenkins
```

En la salida verás una sección que incluye la clave como se muestra en la siguiente imagen.

[logs]


Vamos abrimos cualquier navegador y entramos a la liga [http:localhost](http://localhost:8080). Aquí es donde vamos a acceder a jenkins que está corriendo en un contenedor. Al entrar, jenkins nos mostrará una ventana como la que vemos en la imagen de abajo. Jenkins nos pide una clave de administrador para acceder. Pegamos la clave que copiamos de los logs y continuamos.

Una vez que accedemos a jenkins, se abrirá una ventana como el de la imagen de abajo. Aquí habrá dos opciones: instalar los pluggins que vienen por defecto en jenkins o podemos seleccionar qué plugins instalar. En este caso, vamos a seleccionar la opción por defecto. 

[imagen de plugins]

Nos comenzará a mostrar todos los plugins que se instalaran. Una vez que acaban de instalarse todos los plugins, nos pedirá crear un usuario administrador. Es necesario rellenar los campos que nos muestra la imagen de abajo. Después damos clic a Save and Finish, y volveremos a hacerlo en la siguiente página.

[form]

En este punto, jenkins nos dirá que la instalación está completa como nos muestra la siguiente imagen.

[ready]

Pipeline 💻

Jenkins nos mostrará la página inicial, donde podremos crear cada tarea o configurarlo, como se muestra en la siguiente imagen:

[inicial]

Seleccionaremos la opción “Create a Job”, y se mostrará una ventana con diferentes opciones. Aquí seleccionaremos “Crear un proyecto de estilo libre” y escribiremos un nombre en el campo “Enter an item name”. Finalmente, damos clic en el botón OK.

[estilo]

⸻

Una vez que aceptemos el nombre y la opción, se mostrará la página con la configuración de ese Job. Seleccionamos la pestaña “General”, donde podemos escribir la descripción del pipeline.

Sin embargo, lo más importante aquí es configurar el origen del código. De manera predefinida, esta opción se encontrará en “Ninguno”, pero es necesario seleccionar la opción “Git”, como se muestra en la siguiente imagen:

[git-seleccion]

⸻

Al seleccionar Git, se mostrará un formulario que debemos rellenar:
	•	En “Repository URL”, escribiremos la URL del repositorio que contiene el proyecto.
	•	En “Credentials”, debemos agregar los permisos necesarios para acceder a dicho repositorio.

En el botón “Add”, seleccionaremos la opción “Jenkins”. Aquí configuraremos el acceso al repositorio para que Jenkins pueda descargar el código y generar el artifact a través de la build.

Para esto, es necesario generar un token en la cuenta de GitHub.

⸻

Generación del token en GitHub

Seleccionamos la opción “Settings” desde la cuenta personal (no desde la sección del repositorio). Dentro de Settings, seleccionamos “Developer Settings”, que se encuentra al final del menú. Una vez dentro, seleccionamos “Tokens (classic)” y generamos un nuevo token.

[github - developer setting]

⸻

Configuración de credenciales en Jenkins

Con el token generado, regresamos a la página de Jenkins para configurar las credenciales del repositorio:
	•	En el campo “Username”, agregamos el nombre de usuario de nuestro perfil de GitHub.
	•	En el campo “Password”, pegamos el token que generamos anteriormente en GitHub.
	•	Finalmente, agregamos un identificador en el campo “ID”.

Tal como se muestra en la siguiente imagen:

[jenkins-git-repo]

⸻

Configuración del Build

En la sección “Build Steps”, añadimos un nuevo paso y seleccionamos la opción “Ejecutar tareas Maven de nivel superior”.

En el campo “Goals”, escribimos:

clean install

Finalmente, damos clic en “Apply” y después en “Save” para guardar la configuración del Job. Finalmente, tendremos una serie de opciones del lado izquierdo. Seleccionarás la opción "Construir ahora", y esperarás unos minutos hasta que termine el proceso de build justo como se muestra abajo.

[build-process]

Configuración Webhook 📲

Jenkins necesita saber cuando un desarrollador haga un cambio en el repositorio. Por lo tanto, dado que trabajas de manera local en este proyecto, necesitarás descargar Ngrok. En la siguiente liga encontrarás cómo instalarlo. https://youtu.be/iAgJ6eCgUIA?si=M5sKyC-6wOUyOhRo Básicamente, necesitas Ngrok porque GitHub necesita una URL para enviar el webhook, y avisarle a Jenkins sobre los nuevos cambios. Como no puedes usar localhost:8080, es necesario usar una URL válida. Ngrok ofrece esta URL usando su servicio como "tunel". Tienes tu computadora (la cual tiene una URL inválida http), y necesitas indicar que el puerto 8080 será el que se comunique con el exterior para recibir el mensaje.

Una vez configurado Ngrok (o la herramienta para crear tuneles de tu preferencia), es necesario configurar el webhook. Dentro de tu repositorio, seleccionaras "Settings". Del lado izquierdo, le darás clic a la opción "webhook". En el campo "Payload URL" agregarás la URL que Ngrok te da. Sin embargo, es necesario agregar "/github-webhook/", ya que es el oficial dentro de Jenkins. Los demás campos los dejaras por defecto. Finalmente, en la parte final encontrarás la opción "Which events would you like to trigger this webhook?". Aquí seleccionarás la opción "just the push event". 

[webhook]

En Jenkins, abrirás la ventana de "Configuración" o "Administrar Jenkins", y seleccionarás la opción "System - Configurar variables globales y rutas". Buscarás la opción "Github", ya que aquí agregarás el server. Agregarás tu server personal; por lo tanto, seleccionarás el botón "Add Github server". En el campo "Name" puedes escribir un nombre personal o relacionado al proyecto. El campo "API URL" lo dejarás igual, pero en el campo "Credentials" seleccionarás el botón "Add". Seleccionarás la opción "Jenkins", y se te abrirá la ventana "Jenkins Credentials Provider: Jenkins". En el campo "Kind", seleccionarás la opción "Secret Text". Finalmente, en el campo "Secret" escribirás el token que previamente habías configurado en GitHub.

[window-jenkins-add]

Crearás otro pipeline con la misma configuración anterior. Seleccionarás la opción "GitHub project", y en el campo "Project url" escribirás la URL del repositorio que quieres probar. En la opción "Configurar el origen del código fuente", seleccionarás "Git". En el campo "Repository URL" pegarás otra vez la URL anterior, y en "Credentials" seleccionarás las credenciales que previamente ya habíamos configurado. En la sección "Branches to build", escribirás el término común en el nombre de tus ramas. Comúnmente, las ramas llevan "origin/feature/nombreDeTuEleccion", o "origin/fix/nombreDeTuEleccion". Por lo tanto, puedes escribirlas como "origin/feature/**" o "origin/fix/**". De esa forma, estaría detectando todas esas ramas con ese prefijo. Después, seleccionarás la opción "GitHub hook trigger for GITScm polling" de la sección "Triggers". Finalmente, volverás a seleccionar en la sección "Build Steps" la opción "Ejecutar tareas Maven de nivel superior", y escribirás en Goles "Install clean".

[branches]

