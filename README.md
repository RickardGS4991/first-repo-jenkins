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

Jenkins nos mostrará la página inicial en dónde podremos crear cada tarea o configurarlo como se muestra en la siguiente imagen:

[inicial]

Seleccionarás la opción "Create a Job", y mostrará una ventana con diferentes opciones. Seleccionarás la opción "Crear un proyecto de estilo libre", y escribirás un nombre en el campo "Enter an item name". Darás clic al boton ok.

[estilo]


